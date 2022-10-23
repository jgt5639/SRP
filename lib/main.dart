import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MainApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Songs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bg color
  //Color bgColor = const Color(0XFF2A2A2A); //Colors.black;
  Color bgColor = const Color.fromARGB(255, 36, 48, 94);
  Color twoColor = const Color.fromARGB(255, 55, 71, 133);
  Color threeColor = const Color.fromARGB(255, 247, 108, 108);
  Color fourColor = const Color.fromARGB(255, 248, 233, 161);
  Color fiveColor = const Color.fromARGB(255, 168, 208, 230);

  //define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //today
  //player
  final AudioPlayer _player = AudioPlayer();

  //more variables
  List<SongModel> songs = [];
  String currentSongTitle = '';
  String currentSongArtist = '';
  int currentIndex = 0;

  bool isPlayerViewVisible = false;

  //define a method to set the player view visibility
  void _changePlayerViewVisibility() {
    setState(() {
      isPlayerViewVisible = !isPlayerViewVisible;
    });
  }

  //duration state stream
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          _player.positionStream,
          _player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  //request permission from initStateMethod
  @override
  void initState() {
    super.initState();
    requestStoragePermission();

    //update the current playing song index listener
    _player.currentIndexStream.listen((index) {
      if (index != null) {
        _updateCurrentPlayingSongDetails(index);
      }
    });
  }

  //dispose the player when done
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerViewVisible) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50.0, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [twoColor, bgColor],
              ),
            ),
            child: Column(
              children: <Widget>[
                //exit button and the song title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap:
                            _changePlayerViewVisibility, //hides the player view
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color.fromARGB(255, 248, 233, 161),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: Column(
                        children: [
                          Text(
                            currentSongTitle,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 248, 233, 161),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            currentSongArtist,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 168, 208, 230),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //artwork container
                      Container(
                        width: 300,
                        height: 300,
                        decoration: getDecoration(
                            BoxShape.rectangle, const Offset(2, 2), 15.0, 5.0),
                        margin: const EdgeInsets.only(top: 60, bottom: 50),
                        child: QueryArtworkWidget(
                          id: songs[currentIndex].id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(1.0),
                        ),
                      )
                    ]),

                //slider , position and duration widgets
                Column(
                  children: [
                    //slider bar container
                    Container(
                      padding: EdgeInsets.zero,
                      margin: const EdgeInsets.only(bottom: 4.0),
                      // decoration: getRectDecoration(BorderRadius.circular(20.0),
                      //     const Offset(2, 2), 2.0, 0.0),

                      //slider bar duration state stream
                      child: StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          final progress =
                              durationState?.position ?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return ProgressBar(
                            progress: progress,
                            total: total,
                            barHeight: 7.0,
                            baseBarColor: Color.fromARGB(255, 247, 108, 108),
                            progressBarColor: Color.fromARGB(150, 8, 8, 8),
                            thumbColor:
                                const Color.fromARGB(255, 248, 233, 161),
                            timeLabelTextStyle: const TextStyle(
                              fontSize: 0,
                            ),
                            onSeek: (duration) {
                              _player.seek(duration);
                            },
                          );
                        },
                      ),
                    ),

                    //position /progress and total text
                    StreamBuilder<DurationState>(
                      stream: _durationStateStream,
                      builder: (context, snapshot) {
                        final durationState = snapshot.data;
                        final progress =
                            durationState?.position ?? Duration.zero;
                        final total = durationState?.total ?? Duration.zero;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Text(
                                progress.toString().split(".")[0],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 168, 208, 230),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                total.toString().split(".")[0],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 168, 208, 230),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                //prev, play/pause & seek next control buttons
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //skip to previous
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_player.hasPrevious) {
                              _player.seekToPrevious();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              size: 30,
                              Icons.skip_previous,
                              color: Color.fromARGB(255, 248, 233, 161),
                            ),
                          ),
                        ),
                      ),

                      //play pause
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_player.playing) {
                              _player.pause();
                            } else {
                              if (_player.currentIndex != null) {
                                _player.play();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: StreamBuilder<bool>(
                              stream: _player.playingStream,
                              builder: (context, snapshot) {
                                bool? playingState = snapshot.data;
                                if (playingState != null && playingState) {
                                  return const Icon(
                                    Icons.pause,
                                    size: 50,
                                    color: Color.fromARGB(255, 248, 233, 161),
                                  );
                                }
                                return const Icon(
                                  Icons.play_arrow,
                                  size: 50,
                                  color: Color.fromARGB(255, 248, 233, 161),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      //skip to next
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (_player.hasNext) {
                              _player.seekToNext();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              size: 30,
                              Icons.skip_next,
                              color: Color.fromARGB(255, 248, 233, 161),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //go to playlist, shuffle , repeat all and repeat one control buttons
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    //children: [
                    //   //go to playlist btn
                    //   //shuffle playlist
                    //   Flexible(
                    //     child: InkWell(
                    //       onTap: () {
                    //         _player.setShuffleModeEnabled(true);
                    //         toast(context, "Shuffling enabled");
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(10.0),
                    //         margin:
                    //             const EdgeInsets.only(right: 30.0, left: 30.0),
                    //         decoration: getDecoration(
                    //             BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                    //         child: const Icon(
                    //           Icons.shuffle,
                    //           color: Colors.white70,
                    //         ),
                    //       ),
                    //     ),
                    //   ),

                    //   //repeat mode
                    //   Flexible(
                    //     child: InkWell(
                    //       onTap: () {
                    //         _player.loopMode == LoopMode.one
                    //             ? _player.setLoopMode(LoopMode.all)
                    //             : _player.setLoopMode(LoopMode.one);
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(10.0),
                    //         decoration: getDecoration(
                    //             BoxShape.circle, const Offset(2, 2), 2.0, 0.0),
                    //         child: StreamBuilder<LoopMode>(
                    //           stream: _player.loopModeStream,
                    //           builder: (context, snapshot) {
                    //             final loopMode = snapshot.data;
                    //             if (LoopMode.one == loopMode) {
                    //               return const Icon(
                    //                 Icons.repeat_one,
                    //                 color: Colors.white70,
                    //               );
                    //             }
                    //             return const Icon(
                    //               Icons.repeat,
                    //               color: Colors.white70,
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(
                width: 4, color: Color.fromARGB(255, 168, 208, 230))),

        toolbarHeight: 100,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          "  Library",
          style: TextStyle(
              color: Color.fromARGB(255, 247, 108, 108),
              fontSize: 40,
              fontWeight: FontWeight.w600),
        ),
        //backgroundColor: bgColor,
        elevation: 30,
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, twoColor],
          ),
        ),
        child: FutureBuilder<List<SongModel>>(
          //default values
          future: _audioQuery.querySongs(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            //loading content indicator
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //no songs found
            if (item.data!.isEmpty) {
              return const Center(
                child: Text("No Songs Found"),
              );
            }

            // You can use [item.data!] direct or you can create a list of songs as
            // List<SongModel> songs = item.data!;
            //showing the songs

            //add songs to the song list
            songs.clear();
            songs = item.data!;

            return RawScrollbar(
                //thumbVisibility: true,
                crossAxisMargin: 4,
                radius: Radius.circular(10.0),
                thumbColor: Color.fromARGB(255, 247, 108, 108),
                child: ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 15.0, left: 20.0, right: 20.0),
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListTile(
                          selectedTileColor: fiveColor,
                          textColor: fourColor,
                          title: Text(
                            item.data![index].title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            item.data![index].displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 168, 208, 230),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.more_horiz,
                            color: Color.fromARGB(255, 248, 233, 161),
                          ),
                          leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(10.0),
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                          ),
                          onTap: () async {
                            //show the player view
                            _changePlayerViewVisibility();

                            toast(context,
                                "Playing:  ${item.data![index].title}");
                            // Try to load audio from a source and catch any errors.
                            //  String? uri = item.data![index].uri;
                            // await _player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
                            await _player.setAudioSource(
                                createPlaylist(item.data!),
                                initialIndex: index);
                            await _player.play();
                          },
                        ),
                      );
                    }));
          },
        ),
      ),
    );
  }

  //define a toast method
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }

  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      //ensure build method is called
      setState(() {});
    }
  }

  //create playlist
  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  //update playing song details
  void _updateCurrentPlayingSongDetails(int index) {
    setState(() {
      if (songs.isNotEmpty) {
        currentSongTitle = songs[index].title;
        currentSongArtist = songs[index].artist!;
        currentIndex = index;
      }
    });
  }

  BoxDecoration getDecoration(
      BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
    return BoxDecoration(
      color: bgColor,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: Color.fromARGB(125, 168, 208, 230),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: Color.fromARGB(50, 248, 233, 161),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }

  // BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset,
  //     double blurRadius, double spreadRadius) {
  //   return BoxDecoration(
  //     borderRadius: borderRadius,
  //     color: Color.fromARGB(255, 247, 108, 108),
  //     boxShadow: [
  //       BoxShadow(
  //         offset: -offset,
  //         color: Colors.white24,
  //         blurRadius: blurRadius,
  //         spreadRadius: spreadRadius,
  //       ),
  //       BoxShadow(
  //         offset: offset,
  //         color: Colors.black,
  //         blurRadius: blurRadius,
  //         spreadRadius: spreadRadius,
  //       )
  //     ],
  //   );
  // }
}

//duration class
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
