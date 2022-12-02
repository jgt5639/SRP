import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:senior_project/screens/home_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static const _title = 'flutter_downloader demo';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return MaterialApp(
      title: MyApp._title,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: AnimatedSplashScreen(
        splash: const Icon(Icons.library_music_rounded,
            size: 75, color: Color.fromARGB(255, 247, 108, 108)),
        splashTransition: SplashTransition.sizeTransition,
        backgroundColor: const Color.fromARGB(255, 55, 71, 133),
        nextScreen: MyHomePage(
          title: MyApp._title,
          platform: platform,
        ),
        duration: 3000,
      ),
    );
  }
}
