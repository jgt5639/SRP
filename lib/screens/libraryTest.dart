import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:senior_project/screens/player.dart';

class LibraryScreenTest extends StatefulWidget {
  const LibraryScreenTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LibraryScreenTestState();
}

class LibraryScreenTestState extends State<LibraryScreenTest> {
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
  void _changePlayerViewVisibility([List<SongModel>? list]) {
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
      return const Scaffold(
        body: Text("isPlayerViewVisible"),
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

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Player(item.data)));

                            //_changePlayerViewVisibility(item.data!);

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
