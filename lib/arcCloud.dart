import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
//import 'package:flutter_acrcloud_example/env.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  myAppState createState() => myAppState();
}

// ignore: camel_case_types
class myAppState extends State<MyApp> {
  ACRCloudResponseMusicItem? music;

  @override
  void initState() {
    super.initState();
    const apiKey = '';
    const apiSecret = '';
    const host = '';
    ACRCloud.setUp(const ACRCloudConfig(apiKey, apiSecret, host));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter_ACRCloud example app'),
        ),
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
                    Navigator.pop(context);

                    if (result == null) {
                      // Cancelled.
                      return;
                    } else if (result.metadata == null) {
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
      ),
    );
  }
}
