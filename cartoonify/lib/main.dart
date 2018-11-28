import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cartoonify/homeScreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cartoonify/model.dart';

Future<Null> main() async{
  runApp(new MyApp(
    model: AppModel(),
  ));
}

class MyApp extends StatelessWidget {
  final AppModel model;
  const MyApp({Key key, @required this.model}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        title: "Cartoonify",
        debugShowCheckedModeBanner: false,
        home: new HomeScreen(),
      ),
    );
  }
}