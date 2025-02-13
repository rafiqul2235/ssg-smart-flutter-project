import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
//import 'package:device_info/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/model/response/pdf_report_model.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/report_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../basewidget/custom_loader.dart';
import 'widget/download_list_item.dart';

class PDFListScreen extends StatefulWidget with WidgetsBindingObserver {

  const PDFListScreen({key, required this.title, required this.platform});

  final TargetPlatform platform;

  final String title;

  @override
  _PDFListScreenState createState() => _PDFListScreenState();
}

class _PDFListScreenState extends State<PDFListScreen> {
   List<TaskInfo>? _tasks;
   List<ItemHolder>? _items;
   bool _loading = true;
   bool _permissionReady = false;
   String _localPath = '';
  final ReceivePort _port = ReceivePort();
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    //Provider.of<ReportProvider>(context,listen: false).getPDFReports(context);
    _bindBackgroundIsolate();
    /*FlutterDownloader.registerCallback(downloadCallback, step: 1);*/
    _loading = true;
    _permissionReady = false;
    Timer(const Duration(seconds: 1), () {
      _prepare();
    });

  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );
      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks?.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ?..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')?.send([id, status, progress]);
  }

  void onClickRestore() async {
    var hasGranted = await _checkPermission2();
    if (hasGranted) {
      setState(() {
        _loading = true;
      });
      _deleteSavedFile();
      await _removeTasks();
      _prepare();
    }
  }

  Widget _buildDownloadList() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          for (final item in _items!)
            item.task == null
                ? _buildListSectionHeading(item.name??'')
                : DownloadListItem (
                    data: item,
                    onTap: (task) async {
                      final success = await _openDownloadedFile(task);
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot open this file'),
                          ),
                        );
                      }
                    },
                    onActionTap: (task) {
                      if (task.status == DownloadTaskStatus.undefined) {
                        _requestDownload(task);
                      } else if (task.status == DownloadTaskStatus.running) {
                        _pauseDownload(task);
                      } else if (task.status == DownloadTaskStatus.paused) {
                        _resumeDownload(task);
                      } else if (task.status == DownloadTaskStatus.complete ||
                          task.status == DownloadTaskStatus.canceled) {
                        _delete(task);
                      } else if (task.status == DownloadTaskStatus.failed) {
                        _retryDownload(task);
                      }
                    },
                    onCancel: _delete,
                    onShare: _share,
                  ),
        ],
      );

  Widget _buildListSectionHeading(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorResources.DARK_BLUE,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildNoPermissionWarning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Grant storage permission to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: _retryRequestPermission,
            child: const Text(
              'Retry',
              style: TextStyle(
                color: ColorResources.DARK_BLUE,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = (await FlutterDownloader.enqueue(
      url: task.link??'',
      //headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
      //showNotification: true,
      //openFileFromNotification: true,
      saveInPublicStorage: true,
    ))!;
  }

  // Not used in the example.
  // Future<void> _cancelDownload(TaskInfo task) async {
  //   await FlutterDownloader.cancel(taskId: task.taskId!);
  // }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId!;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId!;
  }

  Future<bool> _openDownloadedFile(TaskInfo task) {
    print('_openDownloadedFile ${task.taskId}');
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId);
    } else {
      return Future.value(false);
    }
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId,
      shouldDeleteContent: true,
    );
    await _prepare();
    setState(() {});
  }

   Future<void> _share(TaskInfo task) async {
     print('_share ${task.link} ${task.name}');
     //FlutterDownloader.
     Share.share(task.link??"");
     //Share.shareFiles(['${directory.path}/image.jpg'], text: 'Great picture');
   }

  Future<bool> _checkPermission() async {

    if (Platform.isIOS) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    //print(' SDK Version ${androidInfo.version.sdkInt}');
    if (widget.platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }


   Future<bool> _checkPermission2() async {
     try {
       if (await Permission.manageExternalStorage
           .request()
           .isGranted) {
         return true;
       } else if (await Permission.manageExternalStorage
           .request()
           .isPermanentlyDenied) {
         await openAppSettings();
         return false;
       } else if (await Permission.manageExternalStorage
           .request()
           .isDenied) {
         return false;
       }else{
         return false;
       }
     }catch(e){
       return false;
     }
   }

  Future<void> _prepare() async {

    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) {
      print('No tasks were retrieved from the database.');
      return;
    }

    var _pdfData = Provider.of<ReportProvider>(context,listen: false).pdfReportLList;

    var count = 0;
    _tasks = [];
    _items = [];

    String category = '';
    for (var i = 0; i < _pdfData.length; i++) {
      PDFReportModel item = _pdfData[i];
      /*if(category.isEmpty){
        category = item.reportCategory;
        _items.add(ItemHolder(name: item.reportCategory));
      }*/
      var task = TaskInfo(name: item.name!, fileName: item.fileName!, link: item.url!);
      _tasks?.add(task);
      if(category!= item.reportCategory){
        category = item.reportCategory!;
        _items?.add(ItemHolder(name: item.reportCategory!));
      }
      _items?.add(ItemHolder(name: item.name!, task: task));

    }

    /*_tasks.addAll(
      DownloadItems.documents.map(
            (document) => TaskInfo(name: document.name, link: document.url),
      ),
    );*/

    /*_items.add(ItemHolder(name: 'Reports'));
    for (var i = count; i < _tasks.length; i++) {
      _items.add(ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }*/

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  /* not done , now it is headrcoded , it will be dynamic*/
  Future<void> _deleteSavedFile() async {
    _localPath = (await _findLocalPath())!;
    var _pdfData = Provider.of<ReportProvider>(context,listen: false).pdfReportLList;
    try {
      for (var i = 0; i < _pdfData.length; i++) {
        PDFReportModel item = _pdfData[i];
        final file = File('$_localPath/${item.fileName}');
        await file.delete();
      }
    } catch (e) {
      //return;
    }
  }

   Future<void> _removeTasks() async {
     final tasks = await FlutterDownloader.loadTasks();
     var pdfData = Provider.of<ReportProvider>(context,listen: false).pdfReportLList;
     if (tasks == null) {
       return;
     }
     try{
       for (final task in tasks) {
         for (final pdf in pdfData) {
           if (pdf.url == task.url) {
             await FlutterDownloader.remove(
               taskId: task.taskId,
               shouldDeleteContent: true,
             );
           }
         }
       }
     }catch(e){}
   }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        // externalStorageDirPath = await AndroidPathProvider.downloadsPath;
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
        //print('_findLocalPath try');
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
        //print('_findLocalPath catch');
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.DARK_BLUE,
        title: Text(widget.title),
        actions: [
          if (Platform.isIOS)
            PopupMenuButton<Function>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => exit(0),
                  child: const ListTile(
                    title: Text('Simulate App Backgrounded',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_loading) {
            return CustomLoader(color: Theme.of(context).primaryColor);
          }
          return _permissionReady
              ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0,top: 10.0, right: 8.0 ),
                    child: Row(
                      children: [
                        Text(getTranslated('RestorePDF', context),style: titilliumSemiBold.copyWith(color: Colors.blue),),
                        IconButton(
                          onPressed: () => onClickRestore(),
                          constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
                          icon: const Icon(Icons.refresh, color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                  Expanded(child: _buildDownloadList())
                ],
              )
              : _buildNoPermissionWarning();
        },
      ),
    );
  }
}

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name,this.fileName,this.link});

  final String? name;
  final String? fileName;
  final String? link;

  String taskId = '';
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
}
