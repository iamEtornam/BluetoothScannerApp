import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
final FlutterBlue _flutterBlue = FlutterBlue.instance;


@override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0,
        title: Text('Bluetooth scanner',style: TextStyle(color: Colors.white,fontSize: 26, fontWeight: FontWeight.bold),)
      ),
      body:  Column(
        children: [
          Spacer(),
          Text('Tap to scan for Bluetooth devices',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white54),),
          SizedBox(height: 10,),
          Center(
            child: InkWell(
              onTap:() async{

              }
              child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              child: Icon(Icons.bluetooth,size: 50,color:Colors.white),
            )
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
