import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() {
    SharedPreferences.getInstance().then((sp){
      if(sp.get("driverToken") != null){
        Navigator.of(context).pushReplacementNamed('/vehicle');
      }
      else{
         Navigator.of(context).pushReplacementNamed('/signIn');
      }
    });
   
  }

  @override
  Widget build(BuildContext context) {
    return new
     Stack(fit: StackFit.expand, children: <Widget>[
      new Image.asset(
        'assets/splash.png',
        fit: BoxFit.fill,
      ),
    ]);
  }
}
