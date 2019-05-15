import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:compliance/common/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:compliance/common/final_report_screen.dart';

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
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp){
      header["Authorization"] = sp.get("driverToken");
    }).then((_){
      http.get(Uri.encodeFull(url),headers: header).then((data){

        Map result = jsonDecode(data.body);

        result.forEach((k1,v1){
          if(k1 == "data"){
            v1.forEach((val1){
              if(val1.containsValue("Inspection Report")){
                val1.forEach((k2,v2){
                  if(k2 == "createdAt"){
                    setState(() {
                      dateVehicleInspection = DateTime.parse(v2);
                    });
                  }
                });
              }
              if(val1.containsValue("Post-Inspection Form")){
                val1.forEach((k2,v2){
                  if(k2 == "createdAt"){
                    setState(() {
                      dateVehicleConditionPost = DateTime.parse(v2);
                    });

                  }
                });
              }
              if(val1.containsValue("Pre-Inspection Form")){
                val1.forEach((k2,v2){
                  if(k2 == "createdAt"){
                    setState(() {
                      dateVehicleConditionPre = DateTime.parse(v2);
                    });

                  }
                });
              }
              if(val1.containsValue("Driver Road Test Form")){
                val1.forEach((k2,v2){
                  if(k2 == "createdAt"){
                    setState(() {
                      dateDriverRoadTest = DateTime.parse(v2);
                    });

                  }
                });
              }
            });
          }
        });
      });
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
                            Text("Driver's road test\nreport",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
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
                            Text("Vehicle condition\nreport (Pre-trip)",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
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
                            Text("Vehicle condition\nreport (Post-Trip)",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
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
                            Text("Vehicle\ninspection report",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
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
