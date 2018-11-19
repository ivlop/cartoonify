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
      body: new Text(
          "Aqui apareceria la foto para transformar\n esta en el path: $_path"
      ),
      floatingActionButton: new IconButton(
        icon: Icon(Icons.check),
        onPressed: (){},
      ),
    );
  }
}