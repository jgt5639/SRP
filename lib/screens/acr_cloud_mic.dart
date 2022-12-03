import 'package:flutter/material.dart';
import 'package:flutter_acrcloud/flutter_acrcloud.dart';
import 'package:senior_project/screens/download_list_item.dart';

class AcrCloudMic extends StatefulWidget {
  const AcrCloudMic({super.key});

  @override
  AcrCloudMicState createState() => AcrCloudMicState();
}

// ignore: camel_case_types
class AcrCloudMicState extends State<AcrCloudMic> {
  ACRCloudResponseMusicItem? music;

  static const apiKey = '6dd61fcd689df7c4f229c702323233d3';
  static const apiSecret = 'o14QDQAUVXyFKmLNra16LcY7DpVkRrhBgOqlthRA';
  static const host = 'identify-eu-west-1.acrcloud.com';

  @override
  void initState() {
    super.initState();

    ACRCloud.setUp(const ACRCloudConfig(apiKey, apiSecret, host));
  }

  Color bgColor = const Color.fromARGB(255, 36, 48, 94);
  Color twoColor = const Color.fromARGB(255, 55, 71, 133);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, twoColor],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(
                builder: (context) => ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(100, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                      backgroundColor: MaterialStateProperty.all(threeColor),
                      shadowColor: MaterialStateProperty.all(fourColor),
                      padding: MaterialStateProperty.all(EdgeInsets.all(15.0))),
                  onPressed: () async {
                    setState(() {
                      music = null;
                    });

                    final session = ACRCloud.startSession();

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        backgroundColor: fiveColor,
                        title: const Text('Listening ...'),
                        content: StreamBuilder(
                          stream: session.volumeStream,
                          initialData: 0,
                          builder: (_, snapshot) =>
                              Text(snapshot.data.toString()),
                        ),
                        actions: [
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(twoColor)),
                            onPressed: session.cancel,
                            child: const Text(
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 248, 233, 161),
                                ),
                                'Cancel'),
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
                  child: const Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color.fromARGB(255, 168, 208, 230),
                      ),
                      'Listen'),
                ),
              ),
              if (music != null) ...[
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  padding: const EdgeInsets.only(top: 20.0),
                  color: fiveColor,
                  width: 300,
                  child: Column(children: [
                    Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        'Title: ${music!.title}\n'),
                    Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        'Artist: ${music!.artists.first.name}\n'),
                    Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        'Album: ${music!.album.name}\n'),
                    Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        'Label: ${music!.label}\n'),
                    Text(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        'Realease Date: ${music!.releaseDate}\n'),
                  ]),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
