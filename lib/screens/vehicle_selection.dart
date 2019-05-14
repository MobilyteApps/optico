import 'dart:async';

import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:compliance/common/drawer.dart';

import 'dart:ui';

class VehicleSelection extends StatefulWidget {
  @override
  VehicleSelectionState createState() => new VehicleSelectionState();
}

class VehicleSelectionState extends State<VehicleSelection> {
  SharedPreferences sharedPreferences;
  List<dynamic> vehicleList = [];
  var dataMap;

  var vehicleId;
  var formId;

  String _vehicle;
  String _mySelection;
  String vehicleName;
  List data1 = List();

  @override
  void initState() {

    super.initState();
    this.getVehicle();
    _vehicle = 'Select Vehicle';
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
      if (sharedPreferences.get("formId") != null) {
        if (sharedPreferences.get("formId") == "driverRoadTrip") {
          setState(() {
            formId = "driverRoadTrip";
          });
        } else if (sharedPreferences.get("formId") == "preInspection") {
          setState(() {
            formId = "preInspection";
          });
        } else if (sharedPreferences.get("formId") == "postInspection") {
          setState(() {
            formId = "postInspection";
          });
        } else if (sharedPreferences.get("formId") == "inspection") {
          setState(() {
            formId = "inspection";
          });
        }
      }
    });
  }

  final String url = 'http://69.160.84.135:3000/api/users/get-vehicle-type';

  Future getVehicle() async {
    http.get(Uri.encodeFull(url)).then((data) {
      Map<String, dynamic> mp = json.decode(data.body);
      if (mp.containsKey("data")) {
        mp.forEach((k, v) {
          if (k == "data") {
            setState(() {
              data1 = v;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(fit: StackFit.expand, children: <Widget>[

      new Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: GestureDetector(
            onTap: ()  {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/vehicle', (Route<dynamic> route) => false);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("SELECT VEHICLE",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
//        drawer: CommonDrawer(),
        body: Container(
          padding: EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            new Expanded(
                child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Theme(
                  data: Theme.of(context).copyWith(brightness: Brightness.light),
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      hint: Text("Select Vehicle",
                          style: TextStyle(color: Colors.black)),
                      items: data1.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(
                            item['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                          value: item['_id'].toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        data1.forEach((val){
                          if(val.containsValue(newVal)){
                            val.forEach((k,v){
                              if(k == "name"){
                                setState(() {
                                  vehicleName = v;
                                });
                              }
                            });
                          }
                        });
                        setState(() {
                          _mySelection = newVal;
                          vehicleId = _mySelection;
                        });
                      },
                      value: _mySelection,
                    ),
                  ),
                ),
              ),
            )),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Color(0xFF0076B5),
              onPressed: () {
                if (vehicleId != null) {
                  SharedPreferences.getInstance().then((sp) {
                    sharedPreferences = sp;
                    sharedPreferences.setString("vehicleName", vehicleName).then((_){
                      sharedPreferences
                          .setString("vehicleId", vehicleId)
                          .then((_) {
                        if (formId == "driverRoadTrip") {
                          Navigator.pushNamed(context, '/driver_form');
                        } else if (formId == "preInspection") {
                          Navigator.pushNamed(context, '/pre_trip_report');
                        } else if (formId == "postInspection") {
                          Navigator.pushNamed(context, '/post_trip_report');
                        } else if (formId == "inspection") {
                          Navigator.pushNamed(context, '/inspection');
                        }
                      });
                    });

                  });print("vehicleId------->"+ vehicleId );

                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0)),
                        title: Center(
                            child: Text(
                          "Warning!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 20.0),
                        )),
                        content: Text(
                          "Please Select Vehicle First!",
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                        actions: <Widget>[
                          Row(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
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
              },
              elevation: 5,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              child: new Text("Go to the Form",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
            ),
          ]),
        ),
      )
    ]);
  }
}
