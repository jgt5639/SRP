import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:senior_project/screens/download_page.dart';

class DownloadListItem extends StatefulWidget {
  const DownloadListItem({
    super.key,
    this.data,
    this.onTap,
    required this.onActionTap,
    this.onCancel,
  });

  final ItemHolder? data;
  final Function(TaskInfo?)? onTap;
  final Function(TaskInfo, String) onActionTap;
  final Function(TaskInfo)? onCancel;

  @override
  State<DownloadListItem> createState() => _DownloadListItemState();
}

class _DownloadListItemState extends State<DownloadListItem> {
  @override
  Widget build(BuildContext context) {
    String THISLINK = '';
    final myController = TextEditingController();

    return GestureDetector(
      onTap: widget.data!.task!.status == DownloadTaskStatus.complete
          ? () {
              widget.onTap!(widget.data!.task);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 8),
        child: InkWell(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Column(
                  children: [
                    TextField(controller: myController),
                    const Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: IconButton(
                        onPressed: () {
                          THISLINK = myController.text;
                          print(THISLINK);
                          widget.onActionTap.call(widget.data!.task!, THISLINK);
                        },
                        constraints:
                            const BoxConstraints(minHeight: 32, minWidth: 32),
                        icon: const Icon(Icons.file_download),
                        tooltip: 'Start',
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.data!.task!.status == DownloadTaskStatus.running ||
                  widget.data!.task!.status == DownloadTaskStatus.paused)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(
                    value: widget.data!.task!.progress! / 100,
                  ),
                )
              else if (widget.data!.task!.status == DownloadTaskStatus.complete)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(
                    value: widget.data!.task!.progress! / 1,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
