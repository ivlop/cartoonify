import 'package:flutter/material.dart';

class TransformedImageScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Image cartoonified"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName))
      ),
    );
  }
  
}