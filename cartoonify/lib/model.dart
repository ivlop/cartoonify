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
import 'package:advanced_share/advanced_share.dart';

class AppModel extends Model{
  int _index = 0;
  Widget _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
  int _buttons = 1;
  String _cartoon64;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _server=false;

  Widget get msg => _msg;
  int get buttons => _buttons;
  int get index => _index;
  String get cartoon64 => _cartoon64;
  bool get server => _server;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    _index++;
    return File('$path/image$index.png');
  }

  Future<File> writeImage(List<int> image) async{
    final file = await _localFile;

    return file.writeAsBytes(image);
  }

  void getImage() async {
      try {
        var photo = await ImagePicker.pickImage(source: ImageSource.camera);
        _server=false;
        _msg = new Text('Getting picture', textScaleFactor: 1.5,);
        _buttons = 2;
        notifyListeners();

        // Reading image
        var image = photo;
        var imageAsBytes = await image.readAsBytes();

        // Creating request
        // NOTE: In the emulator, localhost ip is 10.0.2.2
        //var uri = Uri.parse('http://192.168.43.38:5000/cartoon');  //patri
        var uri = Uri.parse('http://172.30.3.9:5000/cartoon'); //sobremesa
        //var uri = Uri.parse('http://192.168.43.122:5000/cartoon'); //portatil
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
            ],
          );
          notifyListeners();

          var response = await request.send();

          if (response.statusCode == 200) {

            // Receiving response stream
            var responseStr = await response.stream.bytesToString();

            // Converting response string to json dictionary
            var data = jsonDecode(responseStr);

            // Accessing response data
            var cartoon = data['cartoon'];
            _cartoon64 = cartoon;

            if (cartoon != null) {
              // Creating the output file
              var outputFile = await _localFile;
              // Decoding base64 string received as response
              var imageResponse = base64.decode(cartoon);
              // Writing the decoded image to the output file
              await outputFile.writeAsBytes(imageResponse);

              if (!server) {
                _msg = new SizedBox(
                    child: Container(
                      child: new Image.file(outputFile),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    )
                );
                _buttons = 3;
              }
            }
            else {
              _buttons = 1;
            }
            notifyListeners();
          }
        } catch (e) {
          if (!server) {
            showAlert();
          }
        }
      } catch (e) {
        resetMsg();
      }
  }

  void showAlert() {
    _msg = new AlertDialog(
      title: new Row(
        children: <Widget>[
          new Text("Server error  "),
          new Icon(Icons.error, color: Colors.red, size: 30,),
        ],
      ),

      actions: <Widget>[
        new FlatButton(
          onPressed: resetMsg,
          child: new Text("Close", textScaleFactor: 1.2,),
        ),
      ],
    );
    _buttons = 0;
    notifyListeners();
  }



  void resetMsg(){
    _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
    _buttons = 1;
    notifyListeners();
  }

  void resetMsgCancel(){
    _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
    _buttons = 1;
    _server=true;
    notifyListeners();
  }

  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("${appName} isn't installed."),
          duration: new Duration(seconds: 4),
        ));
      }
    }
  }

  void shareImage() {
    AdvancedShare.generic(msg: "Look what I'm doing with Cartoonify!", url: "data:image/png;base64," + cartoon64).then((response) {
      handleResponse(response);
      }
    );
  }
}


