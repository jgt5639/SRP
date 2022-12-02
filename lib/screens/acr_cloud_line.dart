import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';

class AcrCloudLine extends StatefulWidget {
  final SongModel songPassed;

  const AcrCloudLine({super.key, required this.songPassed});

  @override
  AcrCloudLineState createState() => AcrCloudLineState();
}

// ignore: camel_case_types
class AcrCloudLineState extends State<AcrCloudLine> {
  ACRCloudResponseMusicItem? music;

  static const apiKey = '6dd61fcd689df7c4f229c702323233d3';
  static const apiSecret = 'o14QDQAUVXyFKmLNra16LcY7DpVkRrhBgOqlthRA';
  static const host = 'identify-eu-west-1.acrcloud.com';

  @override
  void initState() {
    super.initState();

    ACRCloud.setUp(const ACRCloudConfig(apiKey, apiSecret, host));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25.0),
            ),
            Text('Title: ${widget.songPassed.title}\n'),
            Text('Artist: ${widget.songPassed.artist}\n'),
            Text('Album: ${widget.songPassed.album}\n'),
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  setState(() {
                    music = null;
                  });

                  final session = ACRCloud.startSession();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Finding Metadata ...'),
                      content: StreamBuilder(
                        stream: session.volumeStream,
                        initialData: 0,
                        builder: (_, snapshot) =>
                            Text(snapshot.data.toString()),
                      ),
                      actions: [
                        TextButton(
                          onPressed: session.cancel,
                          child: const Text('Cancel'),
                        )
                      ],
                    ),
                  );

                  final result = await session.result;

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);

                  if (result == null) {
                    // Cancelled.
                    return;
                  } else if (result.metadata == null) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('No result.'),
                    ));
                    return;
                  }

                  setState(() {
                    music = result.metadata!.music.first;
                  });
                },
                child: const Text('Pull Metadata'),
              ),
            ),
            if (music != null) ...[
              Text('Title: ${music!.title}\n'),
              Text('Artist: ${music!.artists.first.name}\n'),
              Text('Album: ${music!.album.name}\n'),
            ],
          ],
        ),
      ),
    );
  }
}
