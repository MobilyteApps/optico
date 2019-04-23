import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:ui';

class CommonDrawer extends StatefulWidget {
  @override
  DrawerState createState() => new DrawerState();
}

class DrawerState extends State<CommonDrawer> {

  SharedPreferences sharedPreferences;
  List<dynamic> vehicleList = [];
  var dataMap;
  var fullName;
  var email;
  var phoneNumber;

  String _vehicle;
  String _mySelection;
  List data1 = List();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
      setState(() {
        print("my name is ${sharedPreferences.get("fullName")}");
        fullName = sharedPreferences.get("fullName");
        email = sharedPreferences.get("emailAddress");
        phoneNumber = sharedPreferences.get("phoneNumber");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0076B5),),
            accountName: fullName == null
                ? Text("")
                : Text(
                    "${fullName}\n${email}",
                    style: TextStyle(fontSize: 20),
                  ),
          ),
          ListTile(
            title: Text(
              "Driver Road Test",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Color(0xFF0076B5),
            ),
            onTap: () {
              SharedPreferences.getInstance().then((sp) {
                sharedPreferences = sp;
                sharedPreferences
                    .setString("formId", "driverRoadTrip")
                    .then((_) {
                  Navigator.of(context).pushNamed("/vehicle_selection");
                });
              });
            },
          ),
          ListTile(
            title: Text(
              "Vehicle Condition Report\n(Pre-trip)",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Color(0xFF0076B5),
            ),
            onTap: () {
              SharedPreferences.getInstance().then((sp) {
                sharedPreferences = sp;
                sharedPreferences
                    .setString("formId", "preInspection")
                    .then((_) {
                  Navigator.of(context).pushNamed("/vehicle_selection");
                });
              });
            },
          ),
          ListTile(
            title: Text(
              "Vehicle Condition Report\n(Post-trip)",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Color(0xFF0076B5),
            ),
            onTap: () {
              SharedPreferences.getInstance().then((sp) {
                sharedPreferences = sp;
                sharedPreferences
                    .setString("formId", "postInspection")
                    .then((_) {
                  Navigator.of(context).pushNamed("/vehicle_selection");
                });
              });
            },
          ),
          ListTile(
            title: Text(
              "Inspection Report",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Color(0xFF0076B5),
            ),
            onTap: () {
              SharedPreferences.getInstance().then((sp) {
                sharedPreferences = sp;
                sharedPreferences
                    .setString("formId", "inspection")
                    .then((_) {
                  Navigator.of(context).pushNamed("/vehicle_selection");
                });
              });
            },
          ),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              SharedPreferences.getInstance().then((sp) {
                sp.clear().then((_) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
