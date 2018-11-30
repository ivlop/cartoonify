import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


class InternalStorage {
  Future<String> get localPath async {
    final directory = await getExternalStorageDirectory();
    new Directory(directory.path+'/Pictures/cartoonify').create(recursive: true);
    return directory.path;
  }

  Future<File> get localPhoto async{
    final path = await localPath;
    return File('$path/Pictures/cartoonify/${_timestamp()}.PNG');
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<File> writePhoto(List<int> photo) async{
    final file = await localPhoto;
    //write the file
    return file.writeAsBytes(photo);
  }

  Future<void> deletePhotos() async{
    final path = await localPath;
    final directory = new Directory(path+'/Pictures/cartoonify');

    directory.list(recursive: true,followLinks: false).listen((FileSystemEntity entity){
      final imageName = entity.path;
      File file = new File(imageName);
      file.delete();
    });
  }

  Future<void> deleteSelectedPhoto(String image) async{
    File file = new File(image);
    file.delete();
  }

}