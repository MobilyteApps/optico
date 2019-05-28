import 'package:flutter/material.dart';
import 'package:compliance/offlinePreview/offlineDriverRoadTripPreview.dart';
import 'package:compliance/offlinePreview/offlineInspectionReportPreview.dart';
import 'package:compliance/offlinePreview/offlineVehicleConditionReport.dart';
import 'package:compliance/common/web_view.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:compliance/database/database_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class OfflineReportScreen extends StatefulWidget {
  OfflineReportScreen({Key key})
      : super(
    key: key,
  );

  @override
  OfflineReportScreenState createState() => OfflineReportScreenState();
}

class OfflineReportScreenState extends State<OfflineReportScreen>{
  Map<String, String> header = new Map();
  var allOfflineData;

  List<dynamic> allData;

  void initState() {
    super.initState();
    allData = List();
    getOfflineData().then((_){
      setState(() {
        allData = allOfflineData.reversed.toList();
      });
      print("all data" + allData.length.toString());
    });
  }

  Future getOfflineData() async{
    DatabaseHelper helper = DatabaseHelper.instance;
    allOfflineData = await helper.queryAllWord();
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    double width = MediaQuery.of(context).size.width;
    return Stack(fit: StackFit.expand, children: <Widget>[

      new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: GestureDetector(
            onTap: ()  {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/vehicle', (Route<dynamic> route) => false);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("Offline Saved Forms",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
        body: Padding(padding: EdgeInsets.only(top: 10.0,),
          child: allData== null ? Center(
            child: Text("No Offline Form Saved",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          ):ListView.builder(
            itemCount: allData.length,
            itemBuilder: (BuildContext context, int index){
              DateTime date1 = DateTime.parse(allData[index]["timestamp"]);
              DateTime date = date1.toLocal();
              var data = jsonDecode(allData[index]["data"]);
              return Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),
                child: InkWell(
                  onTap: (){
                    if(allData[index]["formName"] == "Driver Road Test"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfflinePreviewDriverRoadTrip(
                              data: data,
                            )),
                      );
                    }
                    else if(allData[index]["formName"] == "Inspection Report"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfflinePreviewInspectionReport(
                              data: data,
                              mechanicSignature: base64.decode(allData[index]["mechanicSignature"]),
                              driverSignature: base64.decode(allData[index]["driverSignature"]),
                            )),
                      );
                    }else if(allData[index]["formName"] == "Vehicle Condition Report(Pre-trip)" || allData[index]["formName"] == "Vehicle Condition Report(Post-trip)"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OfflineVehicleConditionReport(
                              data: data,
                            )),
                      );
                    }
                  },
                  child: Container(
                    color: Colors.white,
                    height: 60.0,
                    width: width,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text("${allData[index]["formName"] == "Vehicle Condition Report(Pre-trip)"? "Vehicle Condition\nReport(Pre-trip)" : allData[index]["formName"] == "Vehicle Condition Report(Post-trip)"? "Vehicle Condition\nReport(Post-trip)" : allData[index]["formName"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("${allData[index]["vehicleName"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                date.hour.toInt() > 12 ? Text("${(date.hour.toInt())-12}:${date.minute}PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),) :
                                date.hour.toInt() == 0 ? Text("${(date.hour.toInt())+12}:${date.minute}AM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)  :
                                Text("${date.hour}:${date.minute}AM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                Text("${date.month.toString()}/${date.day.toString()}/${date.year.toString()}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      )
    ]);
  }
}