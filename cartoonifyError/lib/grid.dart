import 'package:flutter/material.dart';

class Galeria extends StatefulWidget{
  GaleriaState createState() => GaleriaState();
}

class GaleriaState extends State<Galeria> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose(){
    tabController.dispose();
    super.dispose();
  }

  TabBar makeTabBar(){
    return TabBar(
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.camera_alt),
          ),
          Tab(
            icon: Icon(Icons.photo),
          ),
        ],
        controller: tabController,
    );
  }

  TabBarView makeTabBarView(tabs){
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Cartoonify"),
          backgroundColor: Colors.orange,
          bottom: makeTabBar(),
        ),
        body: makeTabBarView(<Widget>[TheGridView().build(),SimpleWidget()]),
      ),
    );
  }
}

class SimpleWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("these are the settings"),
    );
  }
}

class TheGridView{
  Card makeGridCell(String name, IconData icon){
    return Card(
      elevation: 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(child: Icon(icon)),
          Text(name),
        ],
      ),
    );
  }

  GridView build(){
    return GridView.count(
      primary: true,
      padding: EdgeInsets.all(1.0),
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: <Widget>[
        makeGridCell("Camera", Icons.camera_alt),
        makeGridCell("Gallery", Icons.photo),
      ],
    );
  }
}