import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:path/path.dart" show dirname;
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:cartoonify/storage.dart';


class AppModel extends Model{
  Widget _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
  String _imageSelected;  //path de la imagen actual en pantalla
  int _buttons = 1;
  String _cartoon64;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final InternalStorage _storage = new InternalStorage();
  bool _server=false;

  Widget get msg => _msg;
  int get buttons => _buttons;
  String get cartoon64 => _cartoon64;
  bool get server => _server;

  void getImage() async {
    try {
      bool res = await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage);
      if (!res) {
        final result = await SimplePermissions.requestPermission(
            Permission.WriteExternalStorage);
        if (result.toString() == "PermissionStatus.denied")
          throw("Storage permission denied");
      }
      try {
        var photo = await ImagePicker.pickImage(source: ImageSource.camera);
        _msg = new Text('Getting picture', textScaleFactor: 1.5,);
        _server=false;

        _buttons = 2;
        notifyListeners();

        // Reading image
        var image = photo;
        var imageAsBytes = await image.readAsBytes();

        // Creating request
        // NOTE: In the emulator, localhost ip is 10.0.2.2
        var uri = Uri.parse('http://192.168.43.38:5000/cartoon');  //patri
        //var uri = Uri.parse('http://172.30.3.9:5000/cartoon'); //sobremesa
        //var uri = Uri.parse('http://192.168.43.122:5000/cartoon'); //portatil
        //var uri = Uri.parse('http://192.168.43.96:5000/cartoon');
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

              // Decoding base64 string received as response
              var imageResponse = base64.decode(cartoon);

              // Writing the decoded image to the output file
              var outputFile = await _storage.writePhoto(imageResponse);

              if (!_server) {
                _msg = new SizedBox(
                    child: Container(
                      child: new Image.file(outputFile),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                    )
                );

                _buttons = 3;
                notifyListeners();
              }
              else {
                _buttons = 1;
                notifyListeners();
              }
            }
          }
        } catch (e) {
          if (!server) {
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
        }
      }
      catch (e) {
        resetMsg();
      }
    }

    catch (e) {
      _permissionDialog();
    }
  }

  void _permissionDialog(){
    _msg = new AlertDialog(
      title: new Row(
        children: <Widget>[
          new Text("Permission denied  "),
          new Icon(Icons.error, color: Colors.red, size: 30,),
        ],
      ),
      content: new Text("Cannot access to internal storage"),
      actions: <Widget>[
        //new Text('Server error', textScaleFactor: 1.5,),
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
    _server = true;
    notifyListeners();
  }

  void gallery() async{

    try {
      bool res = await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage);
      if (!res) {
        final result = await SimplePermissions.requestPermission(
            Permission.WriteExternalStorage);
        if (result.toString() == "PermissionStatus.denied")
          throw("Storage permission denied");
      }
      try {
        _storage.localPath.then((String path) {
          final directory = new Directory(path + '/Pictures/cartoonify');
          directory.exists().then((isThere) {
            if (!isThere) {
              directory.create(recursive: true);
            }
          });
        });
      } catch (e) {
        print("error permisos");
      }
      _msg = new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('Loading gallery', textScaleFactor: 1,),
            JumpingText('...'),
          ]
      );
      notifyListeners();

      List<Container> containers = new List<Container>();
      _storage.localPath.then((String path) {
        final directory = new Directory(path + '/Pictures/cartoonify');
        directory.list(recursive: false, followLinks: false).toList().then((
            List empty) {
          if (empty.isEmpty) {
            _msg = new Text("There are no photos", textScaleFactor: 1.5,);
            _buttons = 5;
            notifyListeners();
          }
        });

        directory.list(recursive: false, followLinks: false).listen((
            FileSystemEntity entity) {
          final imageName = entity.path;
          containers.add(
            new Container(
              child: new InkResponse(
                child: new Image.asset(imageName, fit: BoxFit.fill),
                enableFeedback: true,
                onTap: () => _onTileClicked(imageName),
              ),
            ),
          );

          if (containers.isNotEmpty) {
            _msg = GridView.count(
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              crossAxisCount: 3,
              children: containers,
            );
            _buttons = 4;
          } else {
            _msg = new Text("There are no photos", textScaleFactor: 1.5,);
            _buttons = 5;
          }
          notifyListeners();
        });
      });
    }catch(e){
      _permissionDialog();
    }
  }


  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
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

  void shareImageFromGallery() {
    File file = new File(_imageSelected);
    List<int> imageBytes =  file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    AdvancedShare.generic(msg: "Look what I'm doing with Cartoonify!", url: "data:image/png;base64," + base64Image).then((response) {
      handleResponse(response);
    }
    );
  }

  void requestPermission() async {
    bool res = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    if (!res) {
      final res = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      print("permision result: " + res.toString());
    }
  }


  void _onTileClicked(String image){
    _imageSelected = image;
    _msg = new Container(
      child: new Image.asset(image, fit: BoxFit.fill),
    );
    _buttons=6;
    notifyListeners();
  }

  void _deletePressed() async{
    await _storage.deletePhotos();
    gallery();
  }

  void _deletePhotoPressed() async {
    await _storage.deleteSelectedPhoto(_imageSelected);
    gallery();

  }
  void onDeleteAllPhotosClicked(){
    _showAlert("Want to delete all photos?", _deletePressed);
  }
  void onDeletePhotoClicked(){
    _showAlert("Want to delete this foto?", _deletePhotoPressed);
  }

  void _showAlert(String text, void function()){
    AlertDialog dialog = new AlertDialog(
      title: new Text("Alert", style: TextStyle(fontSize: 25.0),),
      content: new Text(
        text,
        style: new TextStyle(fontSize: 15.0),),
      actions: <Widget>[
        new FlatButton(onPressed: (){gallery();}, child: new Text('No')),
        new FlatButton(onPressed: (){function();}, child: new Text('Yes')),
      ],
    );
    _msg = dialog;
    _buttons = 0;
    notifyListeners();
  }
}

