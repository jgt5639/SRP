import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class Player extends StatefulWidget {
  final List<SongModel> songsPassed;
  final int songIndex;
  final String songTitle;
  const Player({
    Key? key,
    required this.songsPassed,
    required this.songIndex,
    required this.songTitle,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
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
    Color colorPair31 = Colors.yellow, colorPair32 = Colors.deepOrange; //Apears
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
    return Scaffold(
      body: Text(widget.songsPassed.toString()),
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
