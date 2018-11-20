import 'package:flutter/material.dart';

class TransformedImageScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.orange,
        title: new Text("Image cartoonified"),
      ),
      body: new Center(
          child: new Text("imagen cartoonified",
            textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          //onPressed: () => Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName))
          onPressed: () => Navigator.pop(context),
      ),
    );
  }
  
}