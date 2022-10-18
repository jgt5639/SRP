import 'package:flutter/material.dart';
import 'package:senior_project/screens/song_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          body: Container(
            child: const Text("he"),
          ),
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
