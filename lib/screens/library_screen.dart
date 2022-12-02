import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
//define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //today
  //player
  final AudioPlayer _player = AudioPlayer();

  //more variables
  List<SongModel> songs = [];
  String currentSongTitle = '';
  String currentSongArtist = '';
  int currentSongIndex = 0;

  bool isPlayerViewVisible = false;

  //define a method to set the player view visibility
  void _changePlayerViewVisibility() {
    setState(() {
      if (isPlayerViewVisible == true) {
        isPlayerViewVisible = false;
      } else {
        isPlayerViewVisible = true;
      }
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

  // Color changeing stuff
  Color bgColor = const Color.fromARGB(255, 36, 48, 94);
  Color twoColor = const Color.fromARGB(255, 55, 71, 133);
  Color threeColor = const Color.fromARGB(255, 247, 108, 108);
  Color fourColor = const Color.fromARGB(255, 248, 233, 161);
  Color fiveColor = const Color.fromARGB(255, 168, 208, 230);
  List<Color> oppList = [Colors.white, Colors.white];
  List<Color> colorChange() {
    //Color variables to send back.
    Color colorone = Colors.white, colortwo = Colors.white;

    //Establishing Color Pairs.
    Color colorPair11 = Colors.deepPurple,
        colorPair12 = Colors.blueAccent; //Appears
    Color colorPair21 = Colors.blueAccent,
        colorPair22 = Colors.greenAccent; //Appears
    Color colorPair31 = Colors.blue, colorPair32 = Colors.deepOrange; //Apears
    Color colorPair41 = Colors.deepOrange, colorPair42 = Colors.deepPurple;
    //Random number generation.
    Random random = Random();
    int randomNumber = random.nextInt(5);

    if (randomNumber <= 1) {
      colorone = colorPair11;
      colortwo = colorPair12;
      oppList = [colorPair11, colorPair12];
    } else if (randomNumber == 2) {
      colorone = colorPair21;
      colortwo = colorPair22;
      oppList = [colorPair21, colorPair22];
    } else if (randomNumber == 3) {
      colorone = colorPair31;
      colortwo = colorPair32;
      oppList = [colorPair31, colorPair32];
    } else {
      colorone = colorPair41;
      colortwo = colorPair42;
      oppList = [colorPair41, colorPair42];
    }

    List<Color> myList = [colorone, colortwo];
    return myList;
  }

  @override
  Widget build(BuildContext context) {
    /**/
    if (isPlayerViewVisible) {
      return Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colorChange(),
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
                  ],
                ),

                Material(
                  shadowColor: bgColor,
                  elevation: 20,
                  color: const Color.fromARGB(150, 55, 71, 133),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: oppList,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            color: const Color.fromARGB(0, 0, 0, 0), width: 1)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, left: 33, right: 2),
                                  child: Column(children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      currentSongTitle,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color:
                                            Color.fromARGB(255, 248, 233, 161),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),

                          //Artist for song screen
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, left: 33, right: 2),
                                  child: Column(children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      currentSongArtist,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color:
                                            Color.fromARGB(255, 168, 208, 230),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),

                          //artwork container
                          Container(
                            width: 300,
                            height: 300,
                            decoration: getDecoration(BoxShape.rectangle,
                                const Offset(2, 2), 15.0, 5.0),
                            margin: const EdgeInsets.only(top: 10, bottom: 50),
                            child: QueryArtworkWidget(
                              id: songs[currentSongIndex].id,
                              type: ArtworkType.AUDIO,
                              artworkBorder: BorderRadius.circular(1.0),
                            ),
                          ),

                          //slider , position and duration widgets

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
                                final total =
                                    durationState?.total ?? Duration.zero;

                                return ProgressBar(
                                  progress: progress,
                                  total: total,
                                  barHeight: 7.0,
                                  baseBarColor:
                                      const Color.fromARGB(125, 247, 108, 108),
                                  progressBarColor:
                                      const Color.fromARGB(255, 247, 108, 108),
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
                              final total =
                                  durationState?.total ?? Duration.zero;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Text(
                                      progress.toString().split(".")[0],
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 168, 208, 230),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      total.toString().split(".")[0],
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 168, 208, 230),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          //prev, play/pause & seek next control buttons
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      _player.loopMode == LoopMode.one
                                          ? _player.setLoopMode(LoopMode.all)
                                          : _player.setLoopMode(LoopMode.one);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: StreamBuilder<LoopMode>(
                                        stream: _player.loopModeStream,
                                        builder: (context, snapshot) {
                                          final loopMode = snapshot.data;
                                          if (LoopMode.one == loopMode) {
                                            return const Icon(
                                              size: 25,
                                              Icons.repeat_one,
                                              color: Color.fromARGB(
                                                  255, 248, 233, 161),
                                            );
                                          }
                                          return const Icon(
                                            Icons.repeat,
                                            color: Color.fromARGB(
                                                255, 248, 233, 161),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
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
                                        color:
                                            Color.fromARGB(255, 248, 233, 161),
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
                                      // margin: const EdgeInsets.only(
                                      //     right: 20.0, left: 20.0),
                                      child: StreamBuilder<bool>(
                                        stream: _player.playingStream,
                                        builder: (context, snapshot) {
                                          bool? playingState = snapshot.data;
                                          if (playingState != null &&
                                              playingState) {
                                            return const Icon(
                                              Icons.pause,
                                              size: 50,
                                              color: Color.fromARGB(
                                                  255, 248, 233, 161),
                                            );
                                          }
                                          return const Icon(
                                            Icons.play_arrow,
                                            size: 50,
                                            color: Color.fromARGB(
                                                255, 248, 233, 161),
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
                                        color:
                                            Color.fromARGB(255, 248, 233, 161),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      _player.setShuffleModeEnabled(true);
                                      toast(context, "Shuffling enabled");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Icon(
                                        size: 25,
                                        Icons.shuffle,
                                        color:
                                            Color.fromARGB(255, 248, 233, 161),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),

                //go to playlist, shuffle , repeat all and repeat one control buttons
              ],
            ),
          ),
        ),
      );
    }
    /**/
    //
    return Scaffold(
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
                radius: const Radius.circular(10.0),
                thumbColor: threeColor,
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
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            item.data![index].displayNameWOExt,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 168, 208, 230),
                            ),
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
        currentSongIndex = index;
      }
    });
  }

  BoxDecoration getDecoration(
    BoxShape shape,
    Offset offset,
    double blurRadius,
    double spreadRadius,
  ) {
    return BoxDecoration(
      color: bgColor,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: const Color.fromARGB(125, 168, 208, 230),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: const Color.fromARGB(50, 248, 233, 161),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }
}

//duration class
class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
