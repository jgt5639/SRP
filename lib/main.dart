import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:senior_project/screens/player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Column(
        children: [
          SizedBox(
              height: 50,
              width: 50,
              child: Text("Insert Song Name", style: TextStyle(fontSize: 12))),
          SizedBox(
              height: 400,
              width: 400,
              child: Center(
                child: Text("This is where the art cover can go.",
                    style: TextStyle(fontSize: 12)),
              )),
          SizedBox(height: 80, width: 240, child: Player()),
        ],
      ),
    );
  }
}
