import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfflinePreviewDriverRoadTrip extends StatefulWidget {
  final data;
  OfflinePreviewDriverRoadTrip({Key key, this.data})
      : super(
    key: key,
  );
  @override
  _OfflinePreviewDriverRoadTripState createState() => _OfflinePreviewDriverRoadTripState(data);
}

class _OfflinePreviewDriverRoadTripState extends State<OfflinePreviewDriverRoadTrip> {

  var data;
  _OfflinePreviewDriverRoadTripState(this.data);
  var x = 0;

  var report;
  var preTripInspection;
  var placingTheVehicleInMotion;
  var couplingAndUncoupling;
  var backingAndParking;

  var placingTheVehicleInMotionLength = 0.0;


  SharedPreferences sharedPreferences;



  @override
  void initState() {
    super.initState();
    report = jsonDecode(data["Report"]);
    preTripInspection = jsonDecode(data["PRE-TRIP INSPECTION"]);
    placingTheVehicleInMotion = jsonDecode(data["PLACING THE VEHICLE IN MOTION"])["data"];
    couplingAndUncoupling = jsonDecode(data["COUPLING AND UNCOUPLING"]);
    backingAndParking = jsonDecode(data["BACKING AND PARKING"])["data"];
    setState(() {
      placingTheVehicleInMotionLength = (placingTheVehicleInMotion.length) * 400.0;
    });
    print("report is" + report.toString());
    print("preTripInspection is" + preTripInspection.toString());
    print("placingTheVehicleInMotion is" + placingTheVehicleInMotion.toString());
    print("couplingAndUncoupling is" + couplingAndUncoupling.toString());
    print("backingAndParking is" + backingAndParking.toString());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0076B5),
        title: Text(
          "Driver Road Trip",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 50.0,
            width: width,
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Driver Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Container(
            child: report == null? Text(""): Container(
              height: 460,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.white,
                elevation: 3.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: report.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: EdgeInsets.only(left: 15.0,top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(report[index].keys.elementAt(0).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                            Text(report[index].values.elementAt(0).toString()),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: width,
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pre Trip Inspection",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Container(
            child: preTripInspection == null? Text(""): Container(
              height: (preTripInspection.length) * 100.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.white,
                elevation: 3.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: preTripInspection.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: EdgeInsets.only(left: 15.0,top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(preTripInspection[index]["question"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text(preTripInspection[index]["answer"] == 0 ? "Checked" : preTripInspection[index]["answer"] == 1 ? "Repair\n${preTripInspection[index]["comment"].toString()}" : "N/A"),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: width,
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Placing The Vehicle In Motion",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Container(
            child: placingTheVehicleInMotion == null? Text(""): Container(
              height: placingTheVehicleInMotionLength,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.white,
                elevation: 3.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: placingTheVehicleInMotion.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        child: placingTheVehicleInMotion[index] == null? Text(""): Container(
                          height: (placingTheVehicleInMotion[index]["allQuestions"].length) * 70.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: Colors.white,
                            elevation: 3.0,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: placingTheVehicleInMotion[index]["allQuestions"].length,
                                itemBuilder: (BuildContext context, int index1){
                                  if(index1 == 0 && x == 1){
                                    x=0;
                                  }
                                  if(index1 == 1 && x == 0){
                                    --index1;
                                    x=1;
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(left: 15.0,top: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        x == 0 ? Text("Title: "+placingTheVehicleInMotion[index]["titleKey"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),) :
                                        Text(placingTheVehicleInMotion[index]["allQuestions"][index1]["question"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                                        x != 0 ?
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.0),
                                          child: Text(placingTheVehicleInMotion[index]["allQuestions"][index1]["answer"] == 0 ? "Checked" : placingTheVehicleInMotion[index]["allQuestions"][index1]["answer"] == 1 ? "Repair\n${placingTheVehicleInMotion[index]["allQuestions"][index1]["comment"].toString()}" : "N/A"),
                                        ):
                                        Text(""),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: width,
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Coupling And Uncoupling",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Container(
            child: couplingAndUncoupling == null? Text(""): Container(
              height: (couplingAndUncoupling.length) * 60.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.white,
                elevation: 3.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: couplingAndUncoupling.length,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: EdgeInsets.only(left: 15.0,top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(couplingAndUncoupling[index]["question"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text(couplingAndUncoupling[index]["answer"] == 0 ? "Checked" : couplingAndUncoupling[index]["answer"] == 1 ? "Repair\n${couplingAndUncoupling[index]["comment"].toString()}" : "N/A"),
                            ),
                          ],
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: width,
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Backing And Parking",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Container(
            child: backingAndParking == null? Text(""): Container(
              height: (backingAndParking.length) * 400.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.white,
                elevation: 3.0,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: backingAndParking.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        child: backingAndParking[index] == null? Text(""): Container(
                          height: (backingAndParking[index]["allQuestions"].length) * 80.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: Colors.white,
                            elevation: 3.0,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: backingAndParking[index]["allQuestions"].length,
                                itemBuilder: (BuildContext context, int index1){
                                  if(index1 == 0 && x == 1){
                                    x=0;
                                  }
                                  if(index1 == 1 && x == 0){
                                    --index1;
                                    x=1;
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(left: 15.0,top: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        x == 0 ? Text("Title: "+backingAndParking[index]["titleKey"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),) :
                                        Text(backingAndParking[index]["allQuestions"][index1]["question"].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                                        x != 0 ?
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.0),
                                          child: Text(backingAndParking[index]["allQuestions"][index1]["answer"] == 0 ? "Checked" : backingAndParking[index]["allQuestions"][index1]["answer"] == 1 ? "Repair\n${backingAndParking[index]["allQuestions"][index1]["comment"].toString()}" : "N/A"),
                                        ):
                                        Text(""),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
