import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:senior_project/screens/song_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// Make New Function

class MyHomeScreen extends StatefulWidget {
  @override
  MyHomeScreenState createState() => MyHomeScreenState();
}

class MyHomeScreenState extends State<MyHomeScreen> {
  String directory = '';
  List file = [];
  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  //Ok Not just need to populate this list with the list of songs
  List<String> SampleList = [
    'heyWIDTH CHECKERRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRR',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?'
  ];

  _listofFiles() async {}
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.zero,
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const _CustomeAppBar(),
          bottomNavigationBar: const _CustomNavBar(),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    //The List View is Wonky. Edit the Height and Width below for your phone Jose.
                    height: 200,
                    width: 300,
                    child: ListView.builder(
                        itemCount: SampleList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Text(SampleList[index]);
                        })),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                SizedBox(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      tooltip: "Home",
                      icon: const Icon(Icons.home),
                      onPressed: () {},
                    ),
                    IconButton(
                      tooltip: "Play",
                      icon: const Icon(Icons.play_circle_fill_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SongScreen()),
                        );
                      },
                    ),
                    IconButton(
                      tooltip: "Unknown Files",
                      icon: const Icon(Icons.upload_file_rounded),
                      onPressed: () async {},
                    )
                  ],
                ))
              ]),
        ));
  }
}

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 55, 71, 133),
      unselectedItemColor: const Color.fromARGB(255, 247, 108, 108),
      selectedItemColor: const Color.fromARGB(255, 248, 233, 161),
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill_outlined),
          label: "Play",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.upload_file_rounded),
          label: "Unknown Files",
        ),
      ],
      //currentIndex: selectedIndex,
      //onTap: onItemTapped,
    );
  }
}

class _CustomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 36, 48, 94),
      elevation: 0,
      leading: const Text(
        'Library',
        style: TextStyle(
            color: Color.fromARGB(255, 247, 108, 108),
            fontSize: 18,
            fontFamily: 'Schyler'),
      ),
      actions: <Widget>[
        IconButton(
          color: const Color.fromARGB(255, 248, 233, 161),
          icon: const Icon(Icons.my_library_music_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SongScreen()),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
