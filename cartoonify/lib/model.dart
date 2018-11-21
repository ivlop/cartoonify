import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cartoonify/pagesPicker/transformedImageScreen.dart';

class AppModel extends Model{

  File _image;

  File get image => _image;

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _image = image;
    notifyListeners();
  }
  void deletePressed() {
      _image = null;
      notifyListeners();
  }
  void transformPressed(BuildContext context) {
    /*_scaffoldKey.currentState.showSnackBar(
        new SnackBar(duration: new Duration(seconds: 4), content:
        new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Transforming...")
          ],
        ),
        ));*/

    Navigator.push(context,
        new MaterialPageRoute(
            builder: (context) => new TransformedImageScreen()));

    deletePressed();
  }
}


