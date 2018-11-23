import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cartoonify/model.dart';

//void main() => runApp(HomeScreen());/////////////////////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartoonify',
      home: new Scaffold(
        key: _scaffoldKey,
          appBar: new AppBar(
            title: new Text('Cartoonify'),
            backgroundColor: Colors.orange,
          ),
          body: ScopedModelDescendant<AppModel>(
            builder: (context, child, model){
              return Center(child: model.msg);
            }
          ),
          floatingActionButton:ScopedModelDescendant<AppModel>(
              builder: (context, child, model) {
                 return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: model.buttons==0? <Widget>[
                      FloatingActionButton(
                        onPressed: model.getImage,
                        tooltip: 'Take a picture',
                        child: Icon(Icons.photo_camera),
                      ),
                    ]: model.buttons==1? <Widget>[
                      FloatingActionButton.extended(
                        label: new Text("Cancel"),
                        icon: Icon(Icons.cancel,),
                        tooltip: "Cancel transform",
                        backgroundColor: Colors.red,
                        onPressed: model.resetMsg,
                      ),
                    ]: model.buttons==2?<Widget>[
                      FloatingActionButton.extended(
                        label: new Text("Home"),
                        icon: Icon(Icons.home,),
                        tooltip: "Go to beginning",
                        onPressed: model.resetMsg,
                      ),
                    ]: <Widget>[]
                );
              }
          ),
      ),
    );
  }


}