import 'package:flutter/material.dart';
import 'package:senior_project/screens/player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MaterialApp Title',
      home: HomeStatefulWidget(),
    );
  }
}

// dynamic sizing stuff
class HomeStatefulWidget extends StatefulWidget {
  const HomeStatefulWidget({super.key});
  @override
  State<HomeStatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Player(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  // change tab based on index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialApp Title',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("AppBar Title")),
        body: const MyStatelessWidget(),
      ),
    );
  }
}


class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        SizedBox(
            height: 150,
            width: 150,
            child: Center(
              child: Text("This is where the art cover can go.",
                  style: TextStyle(fontSize: 12)),
            )),
        SizedBox(
            height: 150,
            width: 150,
            child: Center(
              child: Text("Insert Song Name", style: TextStyle(fontSize: 12)),
            )),
        SizedBox(height: 80, width: 272, child: Player()),
      ],
    );
  }
}
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
