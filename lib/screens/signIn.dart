import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<dynamic> frontForm = List();

  List<dynamic> rightForm = List();

  List<dynamic> frontFormArmoured = List();

  List<dynamic> rightFormArmoured = List();

  List<dynamic> leftFormArmoured = List();

  List<dynamic> backFormArmoured = List();

  List<dynamic> trailerBackForm = List();

  List<dynamic> leftForm = List();

  List<dynamic> backForm = List();

  List<dynamic> trailerRightForm = List();

  List<dynamic> trailerFrontForm = List();

  List<dynamic> trailerLeftForm = List();

  List<dynamic>  preTripInspection = List();
  List<dynamic>  couplingAndUnCoupling = List();
  Map<String,dynamic> placingTheVehicleInMotion = Map();
  Map<String,dynamic> backingAndParking = Map();

  String url = 'http://69.160.84.135:3000/api/users/login';

  SharedPreferences sharedPreferences;

  Future<dynamic> loginApi(var email, var password) async {
    if (email.length == 0 || password.length == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            title: Center(
                child: Text(
              "Alert",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            content: Text("Email and Password can't be empty."),
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
    } else {
      var inout = {
        "emailAddress": email,
        "password": password,
      };

      try {
        http.post('$url', body: inout).then((data) {
          Map<String, dynamic> mp = json.decode(data.body);

          print("mp is" + mp.toString());

          if (mp.containsKey("data")) {
            mp.forEach((k, v) {
              if (k == "data") {
                SharedPreferences.getInstance().then((sp) {
                  sharedPreferences = sp;

                  sharedPreferences.setString("fullName", v["fullName"]);

                  sharedPreferences.setString("address", v["address"]);

                  sharedPreferences.setString("companyName", v["company"]);

                  sharedPreferences.setString(
                      "emailAddress", v["emailAddress"]);

                  sharedPreferences.setInt("phoneNumber", v["phoneNumber"]);

                  sharedPreferences.setString("license", v["driverLicenceNo"]);
                });
              } else if (k == "token") {
                SharedPreferences.getInstance().then((sp) {
                  sharedPreferences = sp;

                  sharedPreferences.setString("driverToken", v);
                });
              }
            });

            SharedPreferences.getInstance().then((sp) async{
              sharedPreferences = sp;

               http.get("http://69.160.84.135:3000/api/users/get-vehicle-type").then((data) {
                Map<String, dynamic> mp = json.decode(data.body);
                if (mp.containsKey("data")) {
                  SharedPreferences.getInstance().then((sp){
                    sp.setString("offlineVehicles", jsonEncode(mp["data"]));
                  });
                }
              });

               http.get("http://69.160.84.135:3000/api/users/get-vehicle-bodypart").then((data){
                Map<String, dynamic> allData = json.decode(data.body);
                if(allData.containsKey("bodyPartName") && allData.containsKey("trailer")){
                  allData.forEach((key,value){
                    if (key == "bodyPartName")
                    {
                      List bodyPartName = new List();
                      value.forEach((val){
                        bodyPartName.add({"question": val, "answer":  false});
                      });
                      SharedPreferences.getInstance().then((sp){
                        sp.setString("offlineBodyPartName", jsonEncode(bodyPartName));
                      });
                    }
                    if(key == "trailer"){
                      List trailer = new List();
                      value.forEach((val){
                        trailer.add({"question": val, "answer":  false});
                      });
                      SharedPreferences.getInstance().then((sp){
                        sp.setString("offlineTrailer", jsonEncode(trailer));
                      });
                    }
                  });
                }
              });

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
              });

               http.get("http://69.160.84.135:3000/api/users/get-form?formName=Pre-Inspection%20Form&vehicleType=Armored").then((data) {
                 print("in armored");
                Map<String, dynamic> mp = json.decode(data.body);
                if (mp.containsKey("data")) {
                  mp.forEach((k, v) {
                    if (k == "data") {
                      v.forEach((m, frontData) {
                        if (m == "Front") {
                          frontData.forEach((value) {
                            frontFormArmoured.add({"name": value, "check": -1, "comment": null});
                          });
                        } else if (m == "Left") {
                          frontData.forEach((value) {
                            leftFormArmoured.add({"name": value, "check": -1, "comment": null});
                          });
                        } else if (m == "Right") {
                          frontData.forEach((value) {
                            rightFormArmoured.add({"name": value, "check": -1, "comment": null});
                          });
                        } else if (m == "Back") {
                          frontData.forEach((value) {
                            backFormArmoured.add({"name": value, "check": -1, "comment": null});
                          });
                        } else {}
                      });
                    }
                  });
                }
                SharedPreferences.getInstance().then((sp) {
                  sharedPreferences = sp;
                  sharedPreferences.setString("offlineFrontListArmoured", jsonEncode(frontFormArmoured));
                  sharedPreferences.setString("offlineBackListArmoured", jsonEncode(backFormArmoured));
                  sharedPreferences.setString("offlineLeftListArmoured", jsonEncode(leftFormArmoured));
                  sharedPreferences.setString("offlineRightListArmoured", jsonEncode(rightFormArmoured));
                });
              });

               http.get("http://69.160.84.135:3000/api/users/driver-road-test?formName=Driver%20Road%20Test%20Form").then((data){
                Map<String, dynamic> mp = json.decode(data.body);
                mp["data"].forEach((v){
                  Map<dynamic,dynamic> mp1 = v;
                  if(mp1["view"] == "PRE-TRIP INSPECTION"){
                    preTripInspection = mp1["questionary"];
                  }
                  else if(mp1["view"] == "PLACING THE VEHICLE IN MOTION"){
                    placingTheVehicleInMotion[mp1["bodyparts"]] = mp1["questionary"];
                  }
                  else if(mp1["view"] == "COUPLING AND UNCOUPLING"){
                    couplingAndUnCoupling = mp1["questionary"];
                  }
                  else if(mp1["view"] == "BACKING AND PARKING"){
                    backingAndParking[mp1["bodyparts"]] = mp1["questionary"];
                  }
                });
                SharedPreferences.getInstance().then((sp){
                  sp.setString("preTripInspection", jsonEncode(preTripInspection));
                  sp.setString("couplingAndUnCoupling", jsonEncode(couplingAndUnCoupling));
                  sp.setString("backingAndParking", jsonEncode(backingAndParking));
                  sp.setString("placingTheVehicleInMotion", jsonEncode(placingTheVehicleInMotion));
                });
              });

              if (sharedPreferences.get("driverToken") != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/vehicle', (Route<dynamic> route) => false);
              }
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  title: Center(
                      child: Text(
                    "Alert",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  content:
                      Text("Email or Password is wrong.\nPlease try again!"),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.black,
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
        });
      } catch (e) {
        return (e);
      }
    }
  }

  var email;

  var password;

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GestureDetector(onTap: () => SystemChrome.setEnabledSystemUIOverlays([]));

    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(25, 100, 15, 25),
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 220, 0),
              child: Image.asset("assets/car_logo.png",
                  height: 90, width: 200, scale: 3.0),
            ),
            Card(
              elevation: 8,
              margin: EdgeInsets.fromLTRB(8, 35, 8, 20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height / 25),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Hello !",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF0076B5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Login into your account",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF0076B5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                              border: UnderlineInputBorder(),
                              labelText: 'Email ID',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            controller: _emailController,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                              border: UnderlineInputBorder(),
                              labelText: 'Password',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            obscureText: true,
                            controller: _passwordController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 40.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xFF0076B5),
                          onPressed: () => loginApi(
                              _emailController.text, _passwordController.text),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          padding: EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 10.0),
                          child: Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                        SizedBox(height: height / 15),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("/signUp");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 60),
                    Text(
                      "New User? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    Text("Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF0076B5),
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
