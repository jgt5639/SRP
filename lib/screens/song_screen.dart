// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import 'widgets/player_buttons.dart';
import 'widgets/seekbar.dart';

class SongScreen extends StatefulWidget {
  String name;
  String artist;
  SongScreen({required this.name, required this.artist});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  //Song song = Song.songs[0];

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse('asset:///audios/Guitar.mp3')),
      AudioSource.uri(Uri.parse('asset:///audios/8Bit.mp3')),
      AudioSource.uri(Uri.parse('asset:///audios/Simple.mp3')),
    ]));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(
          position,
          duration ?? Duration.zero,
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 48, 94),
        elevation: 0,
      ),
      body: Stack(children: [
        _MusicPlayer(
          seekBarDataStream: _seekBarDataStream,
          audioPlayer: audioPlayer,
          name: widget.name,
          artist: widget.artist,
        )
      ]),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer(
      {Key? key,
      required Stream<SeekBarData> seekBarDataStream,
      required this.audioPlayer,
      required this.name,
      required this.artist})
      : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final String name;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 36, 48, 94),
              Color.fromARGB(255, 55, 71, 133)
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(
                  color: Color.fromARGB(255, 248, 233, 161),
                )),
            const SizedBox(height: 30),
            Text(artist,
                style: TextStyle(color: Color.fromARGB(255, 168, 208, 230))),
            // const Center( ),
            const SizedBox(height: 30),
            StreamBuilder<SeekBarData>(
              stream: _seekBarDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  position: positionData?.position ?? Duration.zero,
                  duration: positionData?.duration ?? Duration.zero,
                  onChangedEnd: audioPlayer.seek,
                );
              },
            ),
            PlayerButtons(audioPlayer: audioPlayer),
          ],
        ),
      ),
    );
  }
}
