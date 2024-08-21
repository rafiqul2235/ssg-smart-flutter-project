import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../apk_download_screen.dart';

class DownloadListItem extends StatelessWidget {
  const DownloadListItem({
    key,
    required this.data,
    required this.onTap,
    required this.onActionTap,
    required this.onCancel,
  });

  final ItemHolder data;
  final Function(TaskInfo) onTap;
  final Function(TaskInfo) onActionTap;
  final Function(TaskInfo) onCancel;

  Widget? _buildTrailing(TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return InkWell(
        onTap: () => onActionTap?.call(task),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: const [
              Text('Download', style: TextStyle(color: Colors.black)),
              SizedBox(width: 6.0,),
              Icon(Icons.file_download),
            ],
          ),
        ),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.pause, color: Colors.red),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.play_arrow, color: Colors.green),
          ),
          if (onCancel != null)
            IconButton(
              onPressed: () => onCancel?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.cancel),
            ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Install', style: TextStyle(color: Colors.green)),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.delete),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Canceled', style: TextStyle(color: Colors.red)),
          if (onActionTap != null)
            IconButton(
              onPressed: () => onActionTap?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.cancel),
            )
        ],
      );
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Failed', style: TextStyle(color: Colors.red)),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.refresh, color: Colors.green),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return const Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.task!.status == DownloadTaskStatus.complete
          ? () {
        onTap(data.task!);
      }
          : null,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: InkWell(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.name!,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _buildTrailing(data.task!),
                    ),
                  ],
                ),
              ),
              if (data.task!.status == DownloadTaskStatus.running ||
                  data.task!.status == DownloadTaskStatus.paused)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(
                    value: data.task!.progress / 100,
                  ),
                )
              /*else if (data.task.status == DownloadTaskStatus.complete)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Text('Ready', style: TextStyle(color: Colors.green)),
                )*/
              ,
            ],
          ),
        ),
      ),
    );
  }
}

