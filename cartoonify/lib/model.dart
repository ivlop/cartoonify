import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import  'dart:io';
import 'package:http/http.dart' as http;
import "package:path/path.dart" show dirname;
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';


class AppModel extends Model{
  int _i = 0;
  Widget _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
  File _image;
  int _buttons = 0;

  Widget get msg => _msg;
  File get image => _image;
  int get buttons => _buttons;

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
    try {
      var photo = await ImagePicker.pickImage(source: ImageSource.camera);
      _msg = new Text('Getting picture', textScaleFactor: 1.5,);
      _buttons = 1;
      notifyListeners();
      // Getting the absolute path to this script file
      var currentPath = dirname(Platform.script.path);
      // Generating  absolute paths for the input/output images
      var pathImage = "$currentPath/../samples/image.jpg";
      var pathCartoon = "$currentPath/../samples/cartoon.png";

      // Reading image
      var image = photo;
      var imageAsBytes = await image.readAsBytes();

      // Creating request
      // NOTE: In the emulator, localhost ip is 10.0.2.2
      //var uri = Uri.parse('http://192.168.43.38:5000/cartoon');  //patri
      //var uri = Uri.parse('http://172.30.3.9:5000/cartoon'); //sobremesa
      var uri = Uri.parse('http://192.168.43.122:5000/cartoon'); //portatil
      var request = http.MultipartRequest("POST", uri);
      var inputFile = http.MultipartFile.fromBytes(
          'image', imageAsBytes, filename: 'image.jpg');
      request.files.add(inputFile);

      try {
        // Sending request and waiting for response
        _msg = new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('Loading ', textScaleFactor: 1,),
            JumpingText('...'),
            //new CircularProgressIndicator(),
            /*JumpingDotsProgressIndicator(
            fontSize: 20.0,
          ),*/
          ],
        );
        notifyListeners();

        var response = await request.send();

        if (response.statusCode == 200) {
          _msg = new Text('ok :)', textScaleFactor: 1.5,
            style: TextStyle(color: Colors.green),);
          notifyListeners();

          // Receiving response stream
          var responseStr = await response.stream.bytesToString();

          // Converting response string to json dictionary
          var data = jsonDecode(responseStr);

          // Accessing response data
          var cartoon = data['cartoon'];

          if (cartoon != null) {
            _msg = new Text('Transforming...', textScaleFactor: 1.5,);
            notifyListeners();

            // Creating the output file
            var outputFile = await _localFile;
            // Decoding base64 string received as response
            var imageResponse = base64.decode(cartoon);
            // Writing the decoded image to the output file
            await outputFile.writeAsBytes(imageResponse);
            _msg = new SizedBox(
              child: Container(
                child: new Image.file(outputFile),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)),
              )
              );

            _buttons = 2;
            notifyListeners();

            //_image = outputFile;
          }
        }
      } catch (e) {
        //print( 'Server is down');
        /*_msg = new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('Server error', textScaleFactor: 1.5,),
          new Icon(Icons.error, color: Colors.red, size: 80,)
        ],
      );*/
        _msg = new AlertDialog(
          title: new Row(
            children: <Widget>[
              new Text("Server error  "),
              new Icon(Icons.error, color: Colors.red, size: 30,),
            ],
          ),

          actions: <Widget>[
            //new Text('Server error', textScaleFactor: 1.5,),
            new FlatButton(
              onPressed: resetMsg,
              child: new Text("Close", textScaleFactor: 1.2,),
            ),
          ], /*: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Server error', textScaleFactor: 1.5,),
            new Icon(Icons.error, color: Colors.red, size: 80,)
          ],
        ),*/
        );
        _buttons = 4;
        notifyListeners();
      }
      finally {
        notifyListeners();
      }
    }
    catch(e){
      resetMsg();
    }
  }

  void deletePressed() {
      _image = null;
      notifyListeners();
  }

  void resetMsg(){
    _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
    _buttons = 0;
    notifyListeners();
  }

}


