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

Color bgColor = const Color.fromARGB(255, 36, 48, 94);
Color twoColor = const Color.fromARGB(255, 55, 71, 133);
Color threeColor = const Color.fromARGB(255, 247, 108, 108);
Color fourColor = const Color.fromARGB(255, 248, 233, 161);
Color fiveColor = const Color.fromARGB(255, 168, 208, 230);
Color white = const Color.fromARGB(255, 255, 255, 255);

class _DownloadListItemState extends State<DownloadListItem> {
  @override
  Widget build(BuildContext context) {
    String thisLink = '';
    final myController = TextEditingController();

    return GestureDetector(
      onTap: widget.data!.task!.status == DownloadTaskStatus.complete
          ? () {
              widget.onTap!(widget.data!.task);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.only(top: 150, left: 16, right: 16),
        child: InkWell(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Column(
                  children: [
                    TextFormField(
                      controller: myController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fiveColor,
                        border: const OutlineInputBorder(),
                        labelText: 'MP3 Link Here',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: IconButton(
                        iconSize: 35,
                        color: const Color.fromARGB(255, 248, 233, 161),
                        onPressed: () {
                          if (!myController.text.endsWith('.mp3')) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content:
                                      Text('Please give a URL ending in .mp3'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            thisLink = myController.text;

                            widget.onActionTap
                                .call(widget.data!.task!, thisLink);
                          }
                        },
                        constraints:
                            const BoxConstraints(minHeight: 25, minWidth: 25),
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
