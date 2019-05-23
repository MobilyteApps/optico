import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:compliance/api/api.dart';
import 'package:compliance/database/sendOfflineData.dart';
import 'package:compliance/common/functions.dart';

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
            accountEmail: Text("$email"),
            decoration: BoxDecoration(color: Color(0xFF0076B5),),
            accountName: fullName == null
                ? Text("")
                : Text(
                    "$fullName",
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
              "Offline Saved Forms",
              style: TextStyle(fontSize: 15),
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Color(0xFF0076B5),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/offline_report_screen");
            },
          ),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              Functions().checkInternetConnection().then((val){
                if(val){
                  SendOfflineData().getOfflineData().then((_){
                    API().logout(context);
                  });
                }
                else{
                  _showAlert(context, "Unable to Logout.\nPlease connect to the internet.");
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future _showAlert(BuildContext context, String message) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          title: Center(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: Color(0xFF0076B5),
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
