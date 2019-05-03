import 'dart:async';

import 'package:flutter/material.dart';
import 'package:compliance/screens/armouredCarScreens/armoured_car_questions_screen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/PreForm.dart';

class ArmouredPartsSelection extends StatefulWidget {
  ArmouredPartsSelection({Key key, listener})
      : super(
    key: key,
  );

  @override
  ArmouredPartsSelectionState createState() => ArmouredPartsSelectionState();
}

class ArmouredPartsSelectionState extends State<ArmouredPartsSelection> {
  final String url =
      'http://69.160.84.135:3000/api/users/get-form/preInspectionForm';
  List<dynamic> frontForm = List();
  List<PreForm> frontList = [];
  List<dynamic> rightForm = List();
  List<PreForm> rightList = [];
  List<dynamic> leftForm = List();
  List<PreForm> leftList = [];
  List<dynamic> backForm = List();
  List<PreForm> backList = [];
  SharedPreferences sharedPreferences;

  bool gotAllData = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp){
      if(sp.get("front") != null && sp.get("back") != null && sp.get("right") != null && sp.get("left") != null){
        this.getPreviousData(sp);
      }
      else{
        this.getDamageVehicle().then((_){
          setState(() {
            gotAllData = true;
          });
        });
      }
    });
  }

  void getPreviousData(SharedPreferences prefs) async{
    String front = prefs.getString("front");
    String back =  prefs.getString("back");
    String left = prefs.getString("left");
    String right = prefs.getString("right");

    final jsonFront = await json.decode(front);
    final jsonBack = await json.decode(back);
    final jsonLeft = await json.decode(left);
    final jsonRight = await json.decode(right);


    setState(() {
      frontList =
           jsonFront.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      backList =  jsonBack.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      leftList =  jsonLeft.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      rightList =
           jsonRight.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      gotAllData = true;
    });



  }

  Future getDamageVehicle() async {
    http.get("http://69.160.84.135:3000/api/users/get-form?formName=Pre-Inspection%20Form").then((data) {
      Map<String, dynamic> mp = json.decode(data.body);
      if (mp.containsKey("data")) {
        mp.forEach((k, v) {
          if (k == "data") {
            v.forEach((m, frontData) {
              if (m == "Front") {
                frontData.forEach((value) {
                  frontForm.add({"name": value, "check": -1, "comment": null});
                });
              } else if (m == "Left") {
                frontData.forEach((value) {
                  leftForm.add({"name": value, "check": -1, "comment": null});
                });
              } else if (m == "Right") {
                frontData.forEach((value) {
                  rightForm.add({"name": value, "check": -1, "comment": null});
                });
              } else if (m == "Back") {
                frontData.forEach((value) {
                  backForm.add({"name": value, "check": -1, "comment": null});
                });
              } else {}
            });
          }
        });
      }

      frontList = frontForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      leftList = leftForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      rightList = rightForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      backList = backForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      SharedPreferences.getInstance().then((sp) {
        sharedPreferences = sp;
        List<Map<String, dynamic>> lst1 = new List();
        List<Map<String, dynamic>> lst2 = new List();
        List<Map<String, dynamic>> lst3 = new List();
        List<Map<String, dynamic>> lst4 = new List();

        for (var value in frontList) {
          

          lst1.add(value.toJson());
        }
        for (var value in leftList) {
          

          lst2.add(value.toJson());
        }
        for (var value in rightList) {
          

          lst3.add(value.toJson());
        }
        for (var value in backList) {
         

          lst4.add(value.toJson());
        }

        sharedPreferences.setString("frontListStart", jsonEncode(lst1));
        sharedPreferences.setString("backListStart", jsonEncode(lst2));
        sharedPreferences.setString("leftListStart", jsonEncode(lst3));
        sharedPreferences.setString("rightListStart", jsonEncode(lst4));
      });

      setState(() {
        gotAllData = true;
      });
    });
  }

  void goToScreen(int index){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArmouredQuestionsScreen(
            backList: backList,
            frontList: frontList,
            rightList: rightList,
            leftList: leftList,
            indexPage: index,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xFF0076B5),
        elevation: 0.0,
      ),
      body: Stack(children: <Widget>[
        Container(
            color: Colors.grey[300],
            child: ListView(children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  0,
                  50,
                ),
                color: Color(0xFF0076B5),
                child: Column(
                  children: <Widget>[
                    Text(
                        "Mark clearly all damaged or deficiencies found by using the following symbols(S):",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15)),
                  ],
                ),
              ),
              Stack(children: <Widget>[
                new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 5),
                    color: Colors.white,
                    elevation: 3.0,
                    child: new Column(children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: height / 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(0);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/armoured_front.png",
                                        width: 150, height: 150),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(1);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/armoured_back.png",
                                        width: 150, height: 150),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height / 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(2);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/armoured_left.png",
                                        width: 150, height: 150),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(3);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/armoured_right.png",
                                        width: 150, height: 150),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ]))
              ])
            ]))
      ]),
    );
  }
}

@override
Widget build(BuildContext context) {
  return null;
}
