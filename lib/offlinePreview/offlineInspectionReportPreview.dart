import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfflinePreviewInspectionReport extends StatefulWidget {
  final data;
  final mechanicSignature;
  final driverSignature;
  OfflinePreviewInspectionReport({Key key, this.data, this.mechanicSignature, this.driverSignature})
      : super(
    key: key,
  );
  @override
  _OfflinePreviewInspectionReportState createState() => _OfflinePreviewInspectionReportState(data,mechanicSignature,driverSignature);
}

class _OfflinePreviewInspectionReportState extends State<OfflinePreviewInspectionReport> {

  var data;
  var mechanicSignature;
  var driverSignature;
  _OfflinePreviewInspectionReportState(this.data,this.mechanicSignature,this.driverSignature);
  var x = 0;

  var report;
  List<String> defectOfVehicle = List();
  List<String> defectOfTrailer = List();


  SharedPreferences sharedPreferences;



  @override
  void initState() {
    super.initState();
    var x = jsonDecode(data["defectOfVehicle"]);
    var y = jsonDecode(data["defectOfTrailer"]);
    List<String> initDefectOfVehicle = List();
    List<String> initDefectOfTrailer = List();
    x.forEach((val){
      if(val["answer"] == true){
        initDefectOfVehicle.add(val["question"]);
      }
    });
    y.forEach((val){
      if(val["answer"] == true){
        initDefectOfTrailer.add(val["question"]);
      }
    });
    setState(() {
      defectOfVehicle = initDefectOfVehicle;
      defectOfTrailer = initDefectOfTrailer;
    });
    print(mechanicSignature.toString());
    print(driverSignature.toString());
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
          "Offline Inspection Report",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Carrier",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Text("${data["Carrier"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Location",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Text("${data["Location"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Date",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Text("${data["Date"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Time",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Text("${data["Time"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Tractor/Truck No",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Text("${data["Vehicle No"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
                    child: Text("Odometer Begin",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0,left: 15.0),
                    child: Text("${data["Odometer Begin"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
                    child: Text("Odometer End",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0,left: 15.0),
                    child: Text("${data["Odometer End"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
                  ),
                ],
              ),
//              Text("Odometer Begin\n${data["Odometer Begin"]}"),
//              Text("Odometer End\n${data["Odometer End"]}"),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Defective Item",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Container(
              width: width,
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(defectOfVehicle.length, (i) => Chip(
                  label: Text(defectOfVehicle[i].toString()),
                  labelStyle: TextStyle(color: Color(0xFFE3E3E35) ),
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Trailer Defective Item",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Container(
              width: width,
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List.generate(defectOfTrailer.length, (i) => Chip(
                  label: Text(defectOfTrailer[i].toString()),
                  labelStyle: TextStyle(color: Color(0xFFE3E3E35) ),
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Remarks",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0,left: 15.0),
            child: Text("${data["Remarks"]}",style: TextStyle(color: Colors.black,fontSize: 15.0),),
          ),
//          Text("Remarks\n${data["Remarks"]}"),

          IgnorePointer(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0,right: 15.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: data["conditonOfTheVehicleIsSatisfactory"] == "true" ? true : false,
                    onChanged: (value) {
                      setState(() {
                        data["conditonOfTheVehicleIsSatisfactory"] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Text("CONDITION OF THE VEHICLE IS SATISFACTORY",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          IgnorePointer(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0,right: 15.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: data["aboveDefectsCorrected"] == "true" ? true : false,
                    onChanged: (value) {
                      setState(() {
                        data["aboveDefectsCorrected"] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Text("ABOVE DEFECTS CORRECTED",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),

          IgnorePointer(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0,right: 15.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: data["aboveDefectsNeedNotBeCorrected"] == "true" ? true : false,
                    onChanged: (value) {
                      setState(() {
                        data["aboveDefectsNeedNotBeCorrected"] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Text("ABOVE DEFECTS NEED NOT BE CORRECTED FOR SAFE OPERATION OF VEHICLE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Mechanic's Signature",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
          ),
          IgnorePointer(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
              child:
              RaisedButton(
                onPressed: (){},
                child: Container(
                  height: 200.0,
                  width: width,
                  child: Image.memory(mechanicSignature),
                ),
              ),

            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
            child: Text("Driver's Signature",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
          ),
          IgnorePointer(
            child: Padding(
              padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
              child:
              RaisedButton(
                onPressed: (){},
                child: Container(
                  height: 200.0,
                  width: width,
                  child: Image.memory(driverSignature),
                ),
              ),

            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
        ],
      ),
    );
  }
}
