import 'dart:async';

import 'package:cartoonify/pages/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<Null> main() async{
  cameras = await availableCameras();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Cartoonify",
      debugShowCheckedModeBanner: false,
      home: new HomeScreen(cameras),
    );
  }
}