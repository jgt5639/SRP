import 'package:flutter/material.dart';
import 'package:senior_project/screens/player.dart';

class MyHomePageTest extends StatefulWidget {
  const MyHomePageTest({Key? key}) : super(key: key);
  @override
  State<MyHomePageTest> createState() => _MyHomePageTestState();
}

class _MyHomePageTestState extends State<MyHomePageTest> {
  // List of different screens
  int pageIndex = 0;
  List<Widget> pageList = [
    const Player(),
    const Player(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 40,
          elevation: 30,
          toolbarHeight: 100,
          backgroundColor: const Color.fromARGB(255, 36, 48, 94),
          shape: const Border(
              bottom: BorderSide(
                  width: 4, color: Color.fromARGB(255, 168, 208, 230))),
          // App Bar title text
          title: const Text(
            "Library",
            style: TextStyle(
                color: Color.fromARGB(255, 247, 108, 108),
                fontSize: 40,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            // App Bar arrow button
            IconButton(
              icon: const Icon(
                Icons.play_arrow_outlined,
                color: Color.fromARGB(255, 248, 233, 161),
              ),
              iconSize: 45,
              // App Bar arrow button on press
              onPressed: () {},
            )
          ]),
      body: pageList[pageIndex],
      bottomNavigationBar: const _CustomNavBar(),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        titleSpacing: 40,
        elevation: 30,
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 36, 48, 94),
        shape: const Border(
            bottom: BorderSide(
                width: 4, color: Color.fromARGB(255, 168, 208, 230))),
        // App Bar title text
        title: const Text(
          "Library",
          style: TextStyle(
              color: Color.fromARGB(255, 247, 108, 108),
              fontSize: 40,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          // App Bar arrow button
          IconButton(
            icon: const Icon(
              Icons.play_arrow_outlined,
              color: Color.fromARGB(255, 248, 233, 161),
            ),
            iconSize: 45,
            // App Bar arrow button on press
            onPressed: () {},
          )
        ]);
  }
}

// custom Navigation Bar
class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
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
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }

  void onItemTapped(int value) {}
}
