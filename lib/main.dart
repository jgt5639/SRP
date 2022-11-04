import 'package:flutter/material.dart';
import 'package:senior_project/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MainApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      /*AnimatedSplashScreen(
        backgroundColor: const Color.fromARGB(255, 36, 48, 94),
        duration: 3000,
        splashTransition: SplashTransition.sizeTransition,
        curve: Curves.easeInCirc,
        splash: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.library_music,
                color: Color.fromARGB(255, 247, 108, 108), size: 75),
          ],
        )),
        nextScreen: const MyHomePage(title: "Songs"),
      ),
      **/
    );
  }
}
