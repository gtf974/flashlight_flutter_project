import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flashlight/flutter_flashlight.dart';
import 'package:permission_handler/permission_handler.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashlight',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flashlight'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlashState flashState = FlashState.off;
  bool _hasFlashlight = false;

  @override
  void initState() {
    super.initState();
    initFlashlight();
  }

  initFlashlight() async {
    bool hasFlash = await Flashlight.hasFlashlight;
    print("Device has flash ? $hasFlash");
    setState(() {
      _hasFlashlight = hasFlash;
    });
  }

  void switchFlashLight() async {

    if (await Permission.camera.request().isGranted) {
      if (_hasFlashlight) {
        switch (flashState) {
          case FlashState.off:
            setState(() {
              flashState = FlashState.on;
              Flashlight.lightOn(); 
            });
            break;
          case FlashState.on:
            setState(() {
              flashState = FlashState.off;
              Flashlight.lightOff(); 
            });
            break;
        }
      } else {
        print("L'appareil n'a pas de flash");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          centerTitle: true,
          title: Text("Flashlight", style:TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: RawMaterialButton(
            fillColor: (flashState == FlashState.on) ? Colors.red  : Color.fromARGB(255, 114, 137, 218),
            child: Icon((flashState == FlashState.on)
                ? Icons.flash_off
                : Icons.flash_off, size: 40.0, color: Colors.white,),
            shape: CircleBorder(),
            elevation: 9.0,
            padding: EdgeInsets.all(40),
            onPressed: () => switchFlashLight(),
          ),
        ),
        backgroundColor: Colors.grey[800],);
  }
}

enum FlashState { on, off }
