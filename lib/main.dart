import 'package:app_settings/app_settings.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
  bool _isOn = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _flutterBlue.state.listen((event) {
      if (event == BluetoothState.off) {
        setState(() {
          _isOn = false;
        });
        AppSettings.openBluetoothSettings();
      } else {
       setState(() {
          _isOn = true;
       });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.blue[900],
        title: Text(
          'B. scanner',
          style: TextStyle(
              color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              Text('Bluetooth ${_isOn ? 'On' : 'Off'}'),
              Switch.adaptive(
                  value: _isOn,
                  onChanged: (value) {
                    setState(() {
                      _isOn = value;
                    });
                  }),
            ],
          )
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 9,
          ),
          Center(
            child: Text(
              'Tap to scan for Bluetooth devices',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white54),
            ),
          ),
          StreamBuilder<bool>(
            stream: FlutterBlue.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data) {
                return Center(
                  child: AvatarGlow(
                    endRadius: 170.0,
                    glowColor: Colors.white,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    animate: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: InkWell(
                        onTap: () async => _flutterBlue.stopScan(),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.bluetooth,
                              size: 100, color: Colors.red[900]),
                        )),
                  ),
                );
              } else {
                return Center(
                  child: AvatarGlow(
                    endRadius: 170.0,
                    glowColor: Colors.white,
                    duration: Duration(milliseconds: 2000),
                    repeat: true,
                    showTwoGlows: true,
                    animate: false,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: InkWell(
                        onTap: () async => _flutterBlue.startScan(
                            timeout: Duration(seconds: 60)),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.bluetooth,
                              size: 100, color: Colors.blue[900]),
                        )),
                  ),
                );
              }
            },
          ),
          StreamBuilder<List<ScanResult>>(
              stream: _flutterBlue.scanResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return SizedBox.shrink();
                }

                if (snapshot.data == null) {
                  return SizedBox.shrink();
                }

                return SizedBox(
                  child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white70,
                          ),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BluetoothDisplayView(
                                        result: snapshot.data[index])));
                          },
                          leading: Text('${index + 1}.',
                              style: TextStyle(color: Colors.white)),
                          title: Text(
                            '${snapshot.data[index].device.name.isEmpty ? 'Not avaliable' : snapshot.data[index].device.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            '${snapshot.data[index].device.id}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        );
                      }),
                );
              })
        ],
      ),
    );
  }
}

class BluetoothDisplayView extends StatelessWidget {
  final ScanResult result;

  const BluetoothDisplayView({Key key, @required this.result})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        backgroundColor: Colors.white,
        title: Text(
          'Bluetooth device detail',
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 21,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Text(
                'Name:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${result.device.name.isEmpty ? 'Not avaliable' : result.device.name}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text(
                'Id:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${result.device.id}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text(
                'Type:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${result.device.type}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
