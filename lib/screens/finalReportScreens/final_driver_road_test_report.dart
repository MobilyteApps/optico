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
          title: Text("Driver Road Test Report",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
//        drawer: CommonDrawer(),
        body:Container(
          child: Text("nsbbnc,kjfkvk,vjmfnvkmd"),
        ) ,
      )
    ]);
  }
}