import 'package:flutter/material.dart';
import 'package:senior_project/screens/acr_cloud_library.dart';
import 'package:senior_project/screens/acr_cloud_mic.dart';
import 'package:senior_project/screens/download_page.dart';

import 'package:senior_project/screens/library_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {Key? key, required String title, required TargetPlatform platform})
      : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // List of different screens
  int pageIndex = 0;
  List<Widget> pageList = [
    const LibraryScreen(),
    const AcrCloudMic(),
    const AcrCloudLibrary(),
    const DownloadPage(
      platform: null,
      title: '',
    ),
  ];

  // List of different screen titles
  List<String> pageTitles = [
    "Library",
    "Find",
    "Unknown",
    "Download",
  ];

// On tapping a Bottom Nav Item, change screen
  void onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: pageTitles[pageIndex]),
      body: pageList[pageIndex],
      // Bottom Nav Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(235, 55, 71, 133),
        unselectedItemColor: const Color.fromARGB(255, 247, 108, 108),
        selectedItemColor: const Color.fromARGB(255, 248, 233, 161),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: "Library",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_new),
            label: "Finder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file_rounded),
            label: "Unknown Files",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_done_outlined),
            label: "Download",
          ),
        ],
        currentIndex: pageIndex,
        onTap: onItemTapped,
      ),
    );
  }
}

// Custom App Bar
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(75.0);
  final String title;

  const CustomAppBar({
    required this.title,
    preferredSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 40,
      elevation: 30,
      toolbarHeight: 100,
      backgroundColor: const Color.fromARGB(255, 36, 48, 94),
      shape: const Border(
          bottom:
              BorderSide(width: 4, color: Color.fromARGB(255, 168, 208, 230))),
      // App Bar title text
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Color.fromARGB(255, 247, 108, 108),
            fontSize: 40,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
