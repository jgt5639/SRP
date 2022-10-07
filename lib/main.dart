import 'package:flutter/material.dart';
import 'package:senior_project/screens/player.dart';

void main() => runApp(const MyApp());

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
