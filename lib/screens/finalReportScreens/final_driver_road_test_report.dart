import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import 'dart:ui';

class FinalDriverRoadTestReport extends StatefulWidget {
  @override
  FinalDriverRoadTestReportState createState() => new FinalDriverRoadTestReportState();
}

class FinalDriverRoadTestReportState extends State<FinalDriverRoadTestReport> {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(fit: StackFit.expand, children: <Widget>[
      new Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: CircularProgressIndicator(),
        ),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: ()  {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/vehicle', (Route<dynamic> route) => false);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("Driver Road Test Report",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
//        body:Padding(padding: EdgeInsets.only(top: 10.0,),
//          child: ListView(
//            children: <Widget>[
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//              Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
//                onTap: (){print("truck1");},
//                child: Container(
//                  color: Colors.white,
//                  height: 60.0,
//                  width: width,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Center(
//                          child: Text("Truck",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text("10:00PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("04/24/2019",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        child: Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Text("3",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),),
//
//            ],
//          ),
//        ) ,
      )
    ]);
  }
}
