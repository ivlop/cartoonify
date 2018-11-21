import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cartoonify/pagesPicker/transformedImageScreen.dart';
import 'dart:convert';
import  'dart:io';
import 'package:http/http.dart' as http;
import "package:path/path.dart" show dirname;
import 'package:path_provider/path_provider.dart';


class AppModel extends Model{
  int _i = 0;

  File _image;

  File get image => _image;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    _i++;
    return File('$path/image$_i.png');
  }


  void getImage() async {
    var photo = await ImagePicker.pickImage(source: ImageSource.camera);

    // Getting the absolute path to this script file
    var currentPath = dirname(Platform.script.path);
    // Generating  absolute paths for the input/output images
    var pathImage="$currentPath/../samples/image.jpg";
    var pathCartoon="$currentPath/../samples/cartoon.png";

    // Reading image
    var image = photo;
    var imageAsBytes = await image.readAsBytes();

    // Creating request
    // NOTE: In the emulator, localhost ip is 10.0.2.2
    var uri = Uri.parse('http://192.168.43.38:5000/cartoon');
    var request = http.MultipartRequest("POST", uri);
    var inputFile = http.MultipartFile.fromBytes('image', imageAsBytes, filename: 'image.jpg');
    request.files.add(inputFile);

    try {
      // Sending request and waiting for response

      var response = await request.send();

      if (response.statusCode == 200) {
        // Receiving response stream
        var responseStr = await response.stream.bytesToString();

        // Converting response string to json dictionary
        var data = jsonDecode(responseStr);

        // Accessing response data
        var cartoon = data['cartoon'];

        if (cartoon != null) {
          // Creating the output file
          var outputFile = await _localFile;
          // Decoding base64 string received as response
          var imageResponse = base64.decode(cartoon);
          // Writing the decoded image to the output file
          await outputFile.writeAsBytes(imageResponse);

          _image = outputFile;
        }
      }
    } catch  (e) {
      print( 'Server is down');
    } finally {
      notifyListeners();
    }


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


