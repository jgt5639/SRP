import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:senior_project/screens/home_screen.dart';
import 'package:senior_project/screens/song_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Material App Title",
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: const Color.fromARGB(255, 247, 108, 108),
            displayColor: const Color.fromARGB(255, 247, 108, 108)),
      ),
      home: MyHomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => MyHomeScreen()),
        GetPage(name: '/song', page: () => const SongScreen()),
        //GetPage(name: '/', page: () => const HomeScreen()),
      ],
    );
  }
}
