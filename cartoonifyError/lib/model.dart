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
  int _i = 0;
  Widget _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
  int _buttons = 0;
  String _cartoon64;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final InternalStorage storage = new InternalStorage();

  Widget get msg => _msg;
  int get buttons => _buttons;
  String get cartoon64 => _cartoon64;


  void getImage() async {
    try {
      bool res = await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage);
      if (!res) {
        final result = await SimplePermissions.requestPermission(
            Permission.WriteExternalStorage);
        if (result.toString() == "PermissionStatus.denied")
          throw("Not enough permission");
      }
      try {
        var photo = await ImagePicker.pickImage(source: ImageSource.camera);
        _msg = new Text('Getting picture', textScaleFactor: 1.5,);


        _buttons = 1;
        notifyListeners();

        // Reading image
        var image = photo;
        var imageAsBytes = await image.readAsBytes();

        // Creating request
        var uri = Uri.parse('http://192.168.43.122:5000/cartoon');
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
            _msg = new Text('ok :)', textScaleFactor: 1.5,
              style: TextStyle(color: Colors.green),);
            notifyListeners();

            // Receiving response stream
            var responseStr = await response.stream.bytesToString();

            // Converting response string to json dictionary
            var data = jsonDecode(responseStr);

            // Accessing response data
            var cartoon = data['cartoon'];
            _cartoon64 = cartoon;

            if (cartoon != null) {
              _msg = new Text('Transforming...', textScaleFactor: 1.5,);
              notifyListeners();
              //print("transforming");

              // Creating the output file
              //var outputFile = await _localFile;
              // Decoding base64 string received as response
              var imageResponse = base64.decode(cartoon);
              // Writing the decoded image to the output file
              var outputFile = await storage.writePhoto(imageResponse);
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
            ],
          );
          _buttons = 5;
          notifyListeners();
        }
        finally {
          notifyListeners();
        }
      }
      catch (e) {
        resetMsg();
      }
    }

    catch (e) {
      _msg = new AlertDialog(
        title: new Row(
          children: <Widget>[
            new Text("Not enough permits  "),
            new Icon(Icons.error, color: Colors.red, size: 30,),
          ],
        ),

        actions: <Widget>[
          //new Text('Server error', textScaleFactor: 1.5,),
          new FlatButton(
            onPressed: resetMsg,
            child: new Text("Close", textScaleFactor: 1.2,),
          ),
        ],
      );
      _buttons = 4;
      notifyListeners();
    }
  }


  void deletePressed() {
      storage.deletePhotos();
      _msg = new Text("There are no photos", textScaleFactor: 1.5,);
      _buttons = 4;
      notifyListeners();
  }

  void resetMsg(){
    _msg = new Text('Take a picture to convert', textScaleFactor: 1.5,);
    _buttons = 0;
    notifyListeners();
  }

  void gallery() {
     try {
       requestPermission();
       storage.localPath.then((String path){
         final directory = new Directory(path+'/Pictures/cartoonify');
       });
     }catch (e) {
       print("error permisos");
     }
       //Future.wait([buildGridTiles()]).then((data){
         buildGridTiles().then((data){
         if(data.isNotEmpty){
           print("galeria");
           _msg = GridView.count(
             crossAxisSpacing: 5.0,
             mainAxisSpacing: 5.0,
             crossAxisCount: 3,
             //children: data.elementAt(0),
             children: data,
           );
           _buttons = 3;
           //});
         }else {
           _msg= new Text("There are no photos", textScaleFactor: 1.5,);
           _buttons = 4;
         }
       }
       );

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

  void shareImageFromGallery() {
    print("share from gallery not implemented yet");
  }

  void requestPermission() async {
    bool res = await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage);
    //print (res.toString());
    if (!res) {
      final res = await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      print("permision result: " + res.toString());
    }
  }

  Future<List<Widget>> buildGridTiles() async{
    final path = await storage.localPath;
    final directory = new Directory(path+'/Pictures/cartoonify');
    List<Container> containers = new List<Container>();

    directory.list(recursive: false,followLinks: false).listen((FileSystemEntity entity){
      final imageName = entity.path;
      print(entity.path);
      containers.add(
        new Container(
          child: new InkResponse(
            child: new Image.asset(imageName, fit: BoxFit.fill),
              enableFeedback: true,
              onTap: () => _onTileClicked(imageName),
            ),
          ),
        );

      containers.isEmpty?print("vacio"):print("no vacio2");
      });
    containers.isEmpty?print("vacio"):print("no vacio");
    return containers;
  }

  void _onTileClicked(String image){
    //debugPrint("You tapped on item $index");
    _msg = new Container(
      child: new Column(
        children: <Widget>[
          new Text('Image: $image'),
          new Image.asset(image, fit: BoxFit.fill),
        ],
      )
    );
    _buttons=5;
    notifyListeners();
  }

  void showAlert(BuildContext context){
    AlertDialog dialog = new AlertDialog(
      content: new Text(
        "Want to delete all pictures?",
        style: new TextStyle(fontSize: 30.0),),
      actions: <Widget>[
        new FlatButton(onPressed: (){gallery();}, child: new Text('No')),
        new FlatButton(onPressed: (){deletePressed();}, child: new Text('Yes')),
      ],
    );

    _msg = dialog;
    notifyListeners();
  }
}


