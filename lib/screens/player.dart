import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:senior_project/screens/commons/player_buttons.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse('asset:///audios/Guitar.mp3')),
      AudioSource.uri(Uri.parse('asset:///audios/8Bit.mp3')),
      AudioSource.uri(Uri.parse('asset:///audios/Simple.mp3')),
    ]))
        .catchError((error) {
      // catch load errors: 404, invalid url ...
      //print("An error occured $error");
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PlayerButtons(_audioPlayer),
      ),
    );
  }
}
