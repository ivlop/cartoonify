import 'dart:io';

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
      bottomNavigationBar: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /*FloatingActionButton.extended(
            icon: Icon(Icons.undo),
            label: Text("Return"),
            onPressed: (){Navigator.pop(context);},
          ),*/
          FloatingActionButton.extended(
            icon: Icon(Icons.check),
            label: Text("Transform"),
            onPressed: (){},
          ),
        ],
      )
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