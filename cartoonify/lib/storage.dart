import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class InternalStorage {
  Future<String> get localPath async {
    final directory = await getExternalStorageDirectory();
    //final directory = await getApplicationDocumentsDirectory();
    //Directory directory;
    new Directory(directory.path+'/Pictures/cartoonify').create(recursive: true);

    /*new Directory('dir/subdir').create(recursive: true).then((Directory dir){
      directory = dir;
      print(dir.path);
    });*/
    return directory.path;
  }



  Future<File> get _localCounter async {
    final path = await localPath;
    //return File('$path/Pictures/cartoonify/counter.txt');
    return File('$path/counter.txt');
  }

  Future<File> get localPhoto async{
    final path = await localPath;
    int i = await readCounter();
    return File('$path/Pictures/cartoonify/${_timestamp()}.PNG');
    //return File('$path/image${i+1}.PNG');

  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<File> writePhoto(List<int> photo) async{
    //Future<File> writePhoto(List<int> photo, int index) async{
    //final path = await localPath;
    //final file = await File('$path/../image$index.PNG');
    final file = await localPhoto;

    //write the file
    return file.writeAsBytes(photo);
  }

  Future<int> readCounter() async {
    try {
      final file = await _localCounter;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localCounter;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<void> deletePhotos() async{
    final path = await localPath;
    final number = await readCounter();
    final directory = new Directory(path+'/Pictures/cartoonify');
    List<Container> containers = new List<Container>();

    directory.list(recursive: true,followLinks: false).listen((FileSystemEntity entity){
      final imageName = entity.path;
      File file = new File(imageName);
      file.delete();
    });
  }

  Future<void> deleteSelectedPhoto(String image) async{
    final path = await localPath;
    //final number = await readCounter();
    //List<Container> containers = new List<Container>();

    //final imageName = entity.path;
    File file = new File(image);
    file.delete();
  }

}