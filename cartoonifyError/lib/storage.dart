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
    return directory.path;
  }

  Future<File> get localPhoto async{
    final path = await localPath;
    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
    return File('$path/Pictures/cartoonify/${timestamp()}.PNG');

  }

  Future<File> writePhoto(List<int> photo) async{
  //Future<File> writePhoto(List<int> photo, int index) async{
    //final path = await localPath;
    //final file = await File('$path/../image$index.PNG');
    final file = await localPhoto;

    //write the file
    return file.writeAsBytes(photo);
  }

  Future deletePhotos() async{
    final path = await localPath;
    final directory = new Directory(path+'/Pictures/cartoonify');

    directory.list(recursive: true,followLinks: false).listen((FileSystemEntity entity){
      final imageName = entity.path;
      File file = new File(imageName);
      file.delete();
    });
  }

}