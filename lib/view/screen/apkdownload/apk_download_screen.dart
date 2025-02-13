import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:ssg_smart2/utill/app_constants.dart';

import 'package:ssg_smart2/view/screen/apkdownload/widget/download_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/color_resources.dart';
import '../../basewidget/custom_loader.dart';
import 'data.dart';

class ApkDownloadScreen extends StatefulWidget with WidgetsBindingObserver {

  ApkDownloadScreen({key, required this.title, required this.platform});

  final TargetPlatform platform;

  final String title;

  @override
  _ApkDownloadScreenState createState() => _ApkDownloadScreenState();
}

class _ApkDownloadScreenState extends State<ApkDownloadScreen> {
  late List<TaskInfo> _tasks;
  late List<ItemHolder> _items;
  late bool _loading;
  late bool _permissionReady;
  late String _localPath;
  final ReceivePort _port = ReceivePort();
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    if(!FlutterDownloader.initialized) {
      FlutterDownloader.initialize();
    }
    FlutterDownloader.registerCallback(downloadCallback , step: 1);
    _loading = true;
    _permissionReady = false;
    _initData();
  }

  void _initData() async {
   // await Provider.of<UserProvider>(context, listen: false).getUserDefault();
    await _removeExistingApk();

    _permissionReady =  await _checkPermission2();
    if(_permissionReady) {
      await _deleteSavedFile();
    }
    _prepare();
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
      //var status =  DownloadTaskStatus.fromInt(data[1] as int);
      final status = _findTaskStatus(data[1] as int) ;
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
            'task ($taskId) is in status ($status) and process ($progress)',
      );
      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }


   DownloadTaskStatus _findTaskStatus(int value) {
    switch (value) {
      case 0:
        return DownloadTaskStatus.undefined;
      case 1:
        return DownloadTaskStatus.enqueued;
      case 2:
        return DownloadTaskStatus.running;
      case 3:
        return DownloadTaskStatus.complete;
      case 4:
        return DownloadTaskStatus.failed;
      case 5:
        return DownloadTaskStatus.canceled;
      case 6:
        return DownloadTaskStatus.paused;
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  //@pragma('vm:entry-point')
  static void downloadCallback(
      String id,
      int status,
      int progress,
      ) {
    print(
      'Callback on background isolate: '
          'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')?.send([id, status, progress]);
  }

  Widget _buildDownloadList() => ListView(
    padding: const EdgeInsets.symmetric(vertical: 16),
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(' App Current Version is ${AppConstants.APP_VERSION_NAME}',style:TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorResources.DARK_BLUE,
          fontSize: 14,
        ) ,),
      ),
      Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 16.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.YELLOW)
              ),
              child: userProvider.appUpdateInfo==null?Text('App is up-to-date'): userProvider.appUpdateInfo!.appVersionCode! > AppConstants.APP_VERSION_CODE?
              Text('App new version is ${userProvider.appUpdateInfo!.appVersionName},\nPlease update the new version.'):Text('App is up-to-date'),
            );
          }
      ),
      for (final item in _items)
        item.task == null
            ? _buildListSectionHeading(item.name)
            : DownloadListItem(
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
      url: task.link,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
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

  Future<bool> _checkPermission() async {

    if (Platform.isIOS) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (widget.platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      try{
        final status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
      }catch(e){}
    } else {
      return true;
    }
    return false;
  }

  Future<void> _removeExistingApk() async {
    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) {
      print('No tasks were retrieved from the database.');
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];
    _tasks.addAll(
      DownloadItems.apks
          .map((apk) => TaskInfo(name: apk.name!, link: apk.url!)),
    );
    _items.add(ItemHolder(name: 'APK File', task: null /*TaskInfo(name: 'Druti Int App', link: '${AppConstants.BASE_URL}API/ApkDownload/FromApp')*/));
    for (var i = count; i < _tasks.length; i++) {
      _items.add(ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    //Remove Existing Apk files
    for (final task in tasks) {
      for (final info in _tasks) {
        if (info.link == task.url) {
          await FlutterDownloader.remove(
            taskId: task.taskId,
            shouldDeleteContent: true,
          );
        }
      }
    }
  }

  Future<void> _deleteSavedFile() async {
    _localPath = (await _findLocalPath())!;
    if (_permissionReady) {
      try {
        final file = File('$_localPath/druti_int_app.apk');
        await file.delete();
      } catch (e) {
        return;
      }
    }
  }

  Future<void> _prepare() async {

    final tasks = await FlutterDownloader.loadTasks();
    if (tasks == null) {
      print('No tasks were retrieved from the database.');
      return;
    }

    /*if(isFirstTime) {
      await _removeExistingApk(tasks);
      isFirstTime = false;
    }*/

    var count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(
      DownloadItems.apks
          .map((apk) => TaskInfo(name: apk.name!, link: apk.url!)),
    );

    _items.add(ItemHolder(name: 'APK File', task: null /*TaskInfo(name: 'Druti Int App', link: '${AppConstants.BASE_URL}API/ApkDownload/FromApp')*/));
    for (var i = count; i < _tasks.length; i++) {
      _items.add(ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks) {
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

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
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
              ? _buildDownloadList()
              : _buildNoPermissionWarning();
        },
      ),
    );
  }
}

class ItemHolder {
  final String name;
  final TaskInfo? task;

  ItemHolder({required this.name, required this.task});

}

class TaskInfo {

  final String name;
  final String link;
  late String taskId;
  late int progress = 0;

  TaskInfo({required this.name, required this.link});

  DownloadTaskStatus status = DownloadTaskStatus.undefined;
}
