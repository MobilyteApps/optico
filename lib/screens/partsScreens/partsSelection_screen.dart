import 'package:flutter/material.dart';
import 'package:compliance/screens/partsScreens/questions_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/PreForm.dart';

class PartsSelection extends StatefulWidget {
  PartsSelection({Key key, listener})
      : super(
    key: key,
  );

  @override
  PartsSelectionState createState() => PartsSelectionState();
}

class PartsSelectionState extends State<PartsSelection> {
  final String url = 'http://69.160.84.135:3000/api/users/get-form/preInspectionForm';


  List<dynamic> frontForm = List();
  List<PreForm> frontList = [];

  List<dynamic> rightForm = List();
  List<PreForm> rightList = [];

  List<dynamic> trailerBackForm = List();
  List<PreForm> trailerBackList = [];

  List<dynamic> leftForm = List();
  List<PreForm> leftList = [];

  List<dynamic> backForm = List();
  List<PreForm> backList = [];

  List<dynamic> trailerRightForm = List();
  List<PreForm> trailerRightList = [];

  List<dynamic> trailerFrontForm = List();
  List<PreForm> trailerFrontList = [];

  List<dynamic> trailerLeftForm = List();
  List<PreForm> trailerLeftList = [];

  SharedPreferences sharedPreferences;

  bool gotAllData = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(( sp) async {
      if( sp.getString("front") != null){
        frontForm =  jsonDecode( sp.getString("front"));
        rightForm = jsonDecode( sp.getString("right"));
        leftForm =  jsonDecode( sp.getString("left"));
        backForm =  jsonDecode( sp.getString("back"));
        trailerRightForm =  jsonDecode( sp.getString("rightSide"));
        trailerFrontForm =  jsonDecode( sp.getString("frontNose"));
        trailerLeftForm =  jsonDecode( sp.getString("leftSide"));
        trailerBackForm =  jsonDecode( sp.getString("rearDoor"));


        frontList = frontForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        leftList = leftForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        rightList = rightForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        backList = backForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        trailerBackList = trailerBackForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        trailerFrontList = trailerFrontForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        trailerRightList = trailerRightForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
        trailerLeftList = trailerLeftForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();

        setState(() {
          gotAllData = true;
        });

      }
      else{
        try{
          final connectivity = await InternetAddress.lookup('google.com');
          if (connectivity.isNotEmpty && connectivity[0].rawAddress.isNotEmpty){
            this.getDamageVehicle().then((_){
              setState(() {
                gotAllData = true;
              });
            });
          }
        }
        on SocketException catch (_){
          frontList = jsonDecode(sp.getString("offlineFrontList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          leftList = jsonDecode(sp.get("offlineLeftList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          rightList = jsonDecode(sp.get("offlineRightList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          backList = jsonDecode(sp.get("offlineBackList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          trailerBackList = jsonDecode(sp.get("offlineTrailerBackList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          trailerFrontList = jsonDecode(sp.get("offlineTrailerFrontList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          trailerRightList = jsonDecode(sp.get("offlineTrailerRightList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          trailerLeftList = jsonDecode(sp.get("offlineTrailerLeftList")).map<PreForm>((i) => PreForm.fromJson(i)).toList();
          setState(() {
            gotAllData = true;
          });
        }
      }
    });

  }

  Future getDamageVehicle() async {
    http.get("http://69.160.84.135:3000/api/users/get-form?formName=Pre-Inspection%20Form&vehicleType=Truck").then((data) {
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
              } else if (m == "trailerBack") {
                frontData.forEach((value) {
                  trailerBackForm.add({"name": value, "check": -1, "comment": null});
                });
              } else if (m == "trailerFront") {
                frontData.forEach((value) {
                  trailerFrontForm.add({"name": value, "check": -1, "comment": null});
                });
              } else if (m == "trailerRight") {
                frontData.forEach((value) {
                  trailerRightForm.add({"name": value, "check": -1, "comment": null});
                });
              } else if (m == "trailerLeft") {
                frontData.forEach((value) {
                  trailerLeftForm.add({"name": value, "check": -1, "comment": null});
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
      trailerBackList = trailerBackForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      trailerFrontList = trailerFrontForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      trailerRightList = trailerRightForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      trailerLeftList = trailerLeftForm.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      SharedPreferences.getInstance().then((sp) {
        sharedPreferences = sp;
        sharedPreferences.setString("offlineFrontList", jsonEncode(frontForm));
        sharedPreferences.setString("offlineBackList", jsonEncode(backForm));
        sharedPreferences.setString("offlineLeftList", jsonEncode(leftForm));
        sharedPreferences.setString("offlineRightList", jsonEncode(rightForm));
        sharedPreferences.setString("offlineTrailerFrontList", jsonEncode(trailerFrontForm));
        sharedPreferences.setString("offlineTrailerBackList", jsonEncode(trailerBackForm));
        sharedPreferences.setString("offlineTrailerRightList", jsonEncode(trailerRightForm));
        sharedPreferences.setString("offlineTrailerLeftList", jsonEncode(trailerLeftForm));
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
          builder: (context) => QuestionsScreen(
            backList: backList,
            frontList: frontList,
            rightList: rightList,
            leftList: leftList,
            trailerRightList: trailerRightList,
            trailerLeftList: trailerLeftList,
            trailerFrontList: trailerFrontList,
            trailerBackList: trailerBackList,
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
                 Card(
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
                                    Image.asset("assets/front.png",
                                        width: 110, height: 110),
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
                                    Image.asset("assets/back.png",
                                        width: 110, height: 110),
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
                                    Image.asset("assets/left.png",
                                        width: 110, height: 110),
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
                                    Image.asset("assets/right.png",
                                        width: 110, height: 110),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(4);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/front_nose.png",
                                        width: 110, height: 110),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(5);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/rear_door.png",
                                        width: 110, height: 110),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(6);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/left_side.png",
                                        width: 110, height: 110),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(gotAllData){
                                    goToScreen(7);
                                  }
                                  else{
                                    CircularProgressIndicator();
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Image.asset("assets/right_side.png",
                                        width: 110, height: 110),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ])),
              ])
            ])),
        gotAllData == true? Container(
          width: 0.0,
          height: 0.0,
        ):
        Container(
          color: Color.fromRGBO(117, 117, 117, 0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ]),
    );
  }
}
