import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:compliance/common/drawer.dart';

import 'dart:ui';

class Vehicle extends StatefulWidget {
  @override
  VehicleState createState() => new VehicleState();
}

class VehicleState extends State<Vehicle> {
  next() {
    Navigator.pushNamed(context, '/part_1_pretrip');
  }

  SharedPreferences sharedPreferences;
  List<dynamic> vehicleList = [];
  var dataMap;

  String _vehicle;
  String _mySelection;
  List data1 = List();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
    });
    _vehicle = 'Select Vehicle';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      new Image.asset(
        'assets/dashboard.png',
        fit: BoxFit.fill,
      ),
      new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
        child: new Container(
          decoration: new BoxDecoration(color: Colors.black12.withOpacity(0.5)),
        ),
      ),
      new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Dashboard",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
        drawer: CommonDrawer(),
      )
    ]);
  }
}
