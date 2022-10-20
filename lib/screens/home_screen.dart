import 'dart:io';

import 'package:flutter/material.dart';
import 'package:senior_project/screens/song_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'dart:io' as io;
// Make New Function

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  MyHomeScreenState createState() => MyHomeScreenState();
}

class MyHomeScreenState extends State<MyHomeScreen> {
  var files;

  void getFiles() async {
    //asyn function to get list of files
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0]
        .rootDir; //storageInfo[1] for SD card, geting the root directory
    var fm = FileManager(root: Directory(root)); //
    files = await fm.filesTree(
        excludedPaths: ["/storage/emulated/0/Android"],
        extensions: ["mp3"] //optional, to filter files, list only mp3 files
        );
    setState(() {}); //update the UI
  }

  List file = [];

  @override
  void initState() {
    getFiles(); //call getFiles() function on initial state.
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    Directory? directory = (await getExternalStorageDirectory());
    setState(() {
      print(
          "PRINTING HERE MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      print(file);

      ///data/user/0/com.example.senior_project/app_flutter/audios/
      file = io.Directory("$directory/audios/").listSync();

      print(file);
    });
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
          //Comment out the bottomNavigationBar below this line to make the bottom set of button disappear.
          bottomNavigationBar: const _CustomNavBar(),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 250,
                  width: MediaQuery.of(context).size.width - 25,
                  child: ListView.separated(
                    itemCount: files?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        title: Text(files[index].path.split('/').last),
                        leading: const Icon(Icons.audiotrack),
                        trailing: const Icon(
                          Icons.play_arrow,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          // you can add Play/push code over here
                        },
                      ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(thickness: 1),

                    /*
                    itemCount: SampleList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(SampleList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(thickness: 1),
                    */
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
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
        'Music Library',
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
