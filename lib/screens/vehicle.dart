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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(onPressed: () => _scaffoldKey.currentState.openDrawer(), icon: Icon(Icons.menu,color: Colors.white,size: 25.0,),),
            ),
            Padding(padding: EdgeInsets.only(left: 10,top: 15),
            child: Text("Dashboard",style: TextStyle(color: Colors.white,fontSize: 30.0),),),
            Padding(padding: EdgeInsets.only(left: 10,top: 15),
              child: Text("You can find history of your inspection\nreports here",style: TextStyle(color: Colors.white,fontSize: 20.0),),),
            Padding(padding: EdgeInsets.only(left: 15,right: 15,top: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){Navigator.of(context)
                          .pushNamedAndRemoveUntil('/final_driver_road_test_report', (Route<dynamic> route) => false);},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON 4/24/2019",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),

                            ),
                            Text("Driver's road test\nreport",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
                            Padding(padding: EdgeInsets.only(top:20,bottom:20),
                              child: Image(image:  AssetImage("assets/pdf_icon.png"),width: width/8,height: 35,),

                            ),
                            //icon
                          ],
                        ),),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 5),),
                  Expanded(
                    child: InkWell(
                      onTap: (){Navigator.of(context)
                          .pushNamedAndRemoveUntil('/final_pre_inspection_report', (Route<dynamic> route) => false);},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON 4/24/2019",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),

                            ),
                            Text("Vehicle condition\nreport (Pre-trip)",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
                            Padding(padding: EdgeInsets.only(top:20,bottom:20),
                              child: Image(image:  AssetImage("assets/pdf_icon.png"),width: width/8,height: 35),

                            ),
                            //icon
                          ],
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15,right: 15,top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){Navigator.of(context)
                          .pushNamedAndRemoveUntil('/final_post_inspection_report', (Route<dynamic> route) => false);},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON 4/24/2019",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
                            Padding(padding: EdgeInsets.only(top:12,bottom:12),
                              child: Image(image:  AssetImage("assets/half_divider.png"),width: width/8,),

                            ),
                            Text("Vehicle condition\nreport (post-trip)",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 18.0),),
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
                      onTap: (){Navigator.of(context)
                          .pushNamedAndRemoveUntil('/final_inspection_report', (Route<dynamic> route) => false);},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 3.0,
                        child: Padding(padding: EdgeInsets.only(top: 10,left: 10),child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("LAST SUBMITTED\nON 4/24/2019",style: TextStyle(color: Colors.grey,fontSize: 13.0),),
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
