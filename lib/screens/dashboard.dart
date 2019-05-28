import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:compliance/common/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:compliance/api/api.dart';
import 'package:compliance/common/final_report_screen.dart';
import 'package:compliance/database/sendOfflineData.dart';

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
  DateTime dateDriverRoadTest;
  DateTime dateVehicleConditionPre;
  DateTime dateVehicleConditionPost;
  DateTime dateVehicleInspection;
  String url = 'http://69.160.84.135:3000/api/users/dashboard-app';

  Map<String, String> header = new Map();
  List data1 = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget showTimer(){
    print("here");
    return SnackBar(content: Text("Multiple Login Found"),);
  }

  @override
  void initState()
  {
    super.initState();
    SharedPreferences.getInstance().then((sp) async {
      try {
        final connectivity = await InternetAddress.lookup('google.com');

        if (connectivity.isNotEmpty && connectivity[0].rawAddress.isNotEmpty) {

          SendOfflineData().getOfflineData();

          header["Authorization"] = sp.get("driverToken");

          http.get(Uri.encodeFull(url), headers: header).then((data) {
            Map result = jsonDecode(data.body);
            print("result is $result");

            if(result["message"] == "Invalid auth token provided."){

              showTimer();

              Timer(
                  Duration(seconds: 3),(){
                API().logout(context);
              }
              );
            }
            else{
              result.forEach((k1, v1) {
                if (k1 == "data") {
                  v1.forEach((val1) async {
                    if (val1.containsValue("Inspection Report")) {
                      await sp.setString("dateVehicleInspection",
                          jsonEncode(val1["createdAt"]));
                      setState(() {
                        dateVehicleInspection = DateTime.parse(val1["createdAt"]);
                      });
                    }
                    if (val1.containsValue("Post-Inspection Form")) {
                      await sp.setString("dateVehicleConditionPost",
                          jsonEncode(val1["createdAt"]));
                      setState(() {
                        dateVehicleConditionPost =
                            DateTime.parse(val1["createdAt"]);
                      });
                    }
                    if (val1.containsValue("Pre-Inspection Form")) {
                      await sp.setString("dateVehicleConditionPre",
                          jsonEncode(val1["createdAt"]));
                      setState(() {
                        dateVehicleConditionPre =
                            DateTime.parse(val1["createdAt"]);
                      });
                    }
                    if (val1.containsValue("Driver Road Test Form")) {
                      await sp.setString("dateDriverRoadTest",
                          jsonEncode(val1["createdAt"]));
                      setState(() {
                        dateDriverRoadTest = DateTime.parse(val1["createdAt"]);
                      });
                    }
                  });
                }
              });
            }


          });
        }
      }
      on SocketException catch (_){
        setState(() {
          dateVehicleInspection = DateTime.parse(jsonDecode(sp.get("dateVehicleInspection")));
          dateVehicleConditionPost = DateTime.parse(jsonDecode(sp.get("dateVehicleConditionPost")));
          dateVehicleConditionPre = DateTime.parse(jsonDecode(sp.get("dateVehicleConditionPre")));
          dateDriverRoadTest = DateTime.parse(jsonDecode(sp.get("dateDriverRoadTest")));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: CommonDrawer(),
      ),
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/background_dashboard.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(padding: EdgeInsets.only(top: 5,left: 10),child: ListView(
          children: <Widget>[
//            RaisedButton(
//              onPressed: (){
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => DatabaseClass()),
//                );
//              },
//              child: Text("click here"),
//            ),
            IconButton(onPressed: () => _scaffoldKey.currentState.openDrawer(), icon: Icon(Icons.menu,color: Colors.white,size: 25.0,),alignment: Alignment.topLeft,),
            Padding(padding: EdgeInsets.only(left: 5,top: 15),
            child: Text("Dashboard",style: TextStyle(color: Colors.white,fontSize: 30.0),),),
            Padding(padding: EdgeInsets.only(left: 5,top: 15),
              child: Text("You can find history of your inspection\nreports here",style: TextStyle(color: Colors.white,fontSize: 20.0),),),
            Padding(padding: EdgeInsets.only(left: 5,right: 15,top: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FinalReportScreen(
                                screenNumber: 0,
                              )),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON ${dateDriverRoadTest == null? "": "${dateDriverRoadTest.month.toString()}/${dateDriverRoadTest.day.toString()}/${dateDriverRoadTest.year.toString()}"}",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),
                            ),
                            Text("DRIVER'S ROAD TEST\nREPORT",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 16.0),),
                            Padding(padding: EdgeInsets.only(top:20,bottom:20),
                              child: Image(image:  AssetImage("assets/pdf_icon.png"),width: width/8,height: 35,),
                            ),
                          ],
                        ),),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 5),),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FinalReportScreen(
                                screenNumber: 1,
                              )),
                        );
                        },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON ${dateVehicleConditionPre == null? "": "${dateVehicleConditionPre.month.toString()}/${dateVehicleConditionPre.day.toString()}/${dateVehicleConditionPre.year.toString()}"}",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),
                            ),
                            Text("VEHICLE CONDITION\nREPORT (PRE-trip)",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 16.0),),
                            Padding(padding: EdgeInsets.only(top:20,bottom:20),
                              child: Image(image:  AssetImage("assets/pdf_icon.png"),width: width/8,height: 35),
                            ),
                          ],
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 5,right: 15,top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FinalReportScreen(
                                screenNumber: 2,
                              )),
                        );
                        },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON ${dateVehicleConditionPost == null? "": "${dateVehicleConditionPost.month.toString()}/${dateVehicleConditionPost.day.toString()}/${dateVehicleConditionPost.year.toString()}"}",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),
                            ),
                            Text("VEHICLE CONDITION\nREPORT (POST-trip)",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 16.0),),
                            Padding(padding: EdgeInsets.only(top:20,bottom:20),
                              child: Image(image:  AssetImage("assets/pdf_icon.png"),width: width/8,height: 35),
                            ),
                          ],
                        ),),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 5),),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FinalReportScreen(
                                screenNumber: 3,
                              )),
                        );
//                        Navigator.of(context)
//                          .pushNamedAndRemoveUntil('/final_inspection_report', (Route<dynamic> route) => false);
                        },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON ${dateVehicleInspection == null? "": "${dateVehicleInspection.month.toString()}/${dateVehicleInspection.day.toString()}/${dateVehicleInspection.year.toString()}"}",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),
                            ),
                            Text("VEHICLE\nINSPECTION REPORT",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 16.0),),
                            Padding(padding: EdgeInsets.only(top:20,bottom:20),
                              child: Image(image:  AssetImage("assets/pdf_icon.png"),width: width/8,height: 35),
                            ),
                          ],
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),),
      ),
    );
  }
}
