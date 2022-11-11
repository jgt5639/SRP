import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';

class AcrCloud extends StatefulWidget {
  const AcrCloud({super.key});

  @override
  AcrCloudState createState() => AcrCloudState();
}

// ignore: camel_case_types
class AcrCloudState extends State<AcrCloud> {
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
                      title: const Text('Listening...'),
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
                child: const Text('Listen'),
              ),
            ),
            if (music != null) ...[
              Text('Track: ${music!.title}\n'),
              Text('Album: ${music!.album.name}\n'),
              Text('Artist: ${music!.artists.first.name}\n'),
            ],
          ],
        ),
      ),
    );
  }
}
