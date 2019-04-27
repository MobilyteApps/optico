import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


import 'dart:ui';

class FinalPreInspectionReport extends StatefulWidget {
  @override
  FinalPreInspectionReportState createState() => new FinalPreInspectionReportState();
}

class FinalPreInspectionReportState extends State<FinalPreInspectionReport> {

  String url = 'http://10.10.30.73:3000/api/users/history/Pre-Inspection%20Form';
  Map<String, String> header = new Map();

  List<dynamic> allData = List();

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp){
      print("here------");
      header["Authorization"] = sp.get("driverToken");
    }).then((_){
      http.get("http://10.10.30.73:3000/api/users/history/Pre-Inspection%20Form",headers: header).then((data){


        Map result = jsonDecode(data.body);

        result.forEach((k,v){
          if(k == "date"){
            setState(() {
              allData = v;
            });
          }
        });
        print("${result.toString()}");
      }).catchError((err){
        print("${err.toString()}");
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
          title: Text("Vehicle Condition Report(Pre-Trip)",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
//        drawer: CommonDrawer(),
        body: Padding(padding: EdgeInsets.only(top: 10.0,),
          child: allData.length == null? CircularProgressIndicator():ListView.builder(
            itemCount: allData.length,
            itemBuilder: (BuildContext context, int index){
              DateTime date = DateTime.parse(allData[index]["date"]);
              return Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
                onTap: (){print("truck");},
                child: Container(
                  color: Colors.white,
                  height: 60.0,
                  width: width,
                  child: Row(
                    children: <Widget>[
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
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("${allData[index]["countOfDefect"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),);
            },
          ),
        ),
      )
    ]);
  }
}
