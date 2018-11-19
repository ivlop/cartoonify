import 'dart:io';

import 'package:cartoonify/pages/transformedImageScreen.dart';
import 'package:flutter/material.dart';


class TransformScreen extends StatelessWidget {
  final _path;
  TransformScreen(this._path);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Transform page"),
        backgroundColor: Colors.green,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _thumbnailWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        icon: Icon(Icons.check),
        label: Text("Transform"),
        onPressed: () => Navigator.pushReplacement(context,
            new MaterialPageRoute(
                builder: (context) => new TransformedImageScreen())),
        ),
    );
  }

  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: _path == null
            ? null
            : SizedBox(
          child: (null == null)
              ? Image.file(File(_path))
              : Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}