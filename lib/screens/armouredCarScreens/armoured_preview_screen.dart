import 'dart:io';
import 'package:compliance/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:compliance/modals/PreForm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArmouredPreview extends StatefulWidget {
  @override
  _ArmouredPreviewState createState() => _ArmouredPreviewState();
}

class _ArmouredPreviewState extends State<ArmouredPreview> {
  List<PreForm> previewList = [];
  List<PreForm> frontList = [];
  List<PreForm> backList = [];
  List<PreForm> leftList = [];
  List<PreForm> rightList = [];
  SharedPreferences sharedPreferences;
  List<PreForm> couplingList;
  var driverReport;
  var dataTOSend = {};
  bool submitted = true;
  double previewLength = 3000;


  String url = "http://69.160.84.135:3000/api/users/driver-road-trip";

  String formId;

  void onEdit(){
    if(formId == "preInspection"){
      Navigator.pushNamed(context, '/pre_trip_report');
    }
    else{
      Navigator.pushNamed(context, '/post_trip_report');
    }
  }

  Future _showAlert(BuildContext context, String message) async {
    await SharedPreferences.getInstance().then((sp) async {
      sharedPreferences = sp;
      Map<String, String> header = new Map();
      header["Content-Type"] = "application/x-www-form-urlencoded";
      header["Authorization"] = sharedPreferences.get("driverToken");

      if (frontList.length != null) {
        List<Map<String, dynamic>> lst1 = new List();
        for (var value in frontList) {
          lst1.add(value.toJson());
        }

        dataTOSend["Front"] = lst1;
      }
      if (backList.length != null) {
        List<Map<String, dynamic>> lst2 = new List();
        for (var value in backList) {
          lst2.add(value.toJson());
        }

        dataTOSend["Back"] = lst2;
      }

      if (leftList.length != null) {
        List<Map<String, dynamic>> lst2 = new List();
        for (var value in leftList) {
          lst2.add(value.toJson());
        }

        dataTOSend["Left"] = lst2;
      }
      if (rightList.length != null) {
        List<Map<String, dynamic>> lst2 = new List();
        for (var value in rightList) {
          lst2.add(value.toJson());
        }

        dataTOSend["Right"] = lst2;
      }

      if (formId == "preInspection") {
        Map<String, dynamic>  mpPreTripReport = <String, dynamic>{
          "vehicleType": sharedPreferences.get("vehicleId"),
          "defectiveParts": jsonEncode(dataTOSend),
          "Report": sharedPreferences.get("preTripReportNew"),
          "driverId": sharedPreferences.get("driverToken"),
          "formName" : "Pre-Inspection Form"
        };

        try{
          final connectivity = await InternetAddress.lookup('google.com');
          if (connectivity.isNotEmpty && connectivity[0].rawAddress.isNotEmpty){
            await http.post(
                "http://69.160.84.135:3000/api/users/driver-road-trip",
                body: mpPreTripReport,
                headers: header).then((_){
              setState(() {
                submitted = true;
              });
            });
          }
        }
        on SocketException catch (_){
          SharedPreferences.getInstance().then((sp)async{
            OfflineData offlineData = OfflineData();
            offlineData.vehicleName = sharedPreferences.get("vehicleName");
            offlineData.data = jsonEncode(mpPreTripReport);
            offlineData.formName = "Vehicle Condition Report(Pre-trip)";
            offlineData.userToken = sharedPreferences.get("driverToken");
            DatabaseHelper helper = DatabaseHelper.instance;
            int id = await helper.insert(offlineData);
            print('inserted row: $id');
          });
        }
      } else if (formId == "postInspection") {
        Map<String, dynamic> mpPostTripReport = <String, dynamic>{
          "vehicleType": sharedPreferences.get("vehicleId"),
          "defectiveParts": jsonEncode(dataTOSend),
          "Report": sharedPreferences.get("postTripReportNew"),
          "driverId": sharedPreferences.get("driverToken"),
          "formName" : "Post-Inspection Form"
        };


        try{
          final connectivity = await InternetAddress.lookup('google.com');
          if (connectivity.isNotEmpty && connectivity[0].rawAddress.isNotEmpty){
              await http.post(
                "http://69.160.84.135:3000/api/users/driver-road-trip",
                  body: mpPostTripReport,
                   headers: header).then((_){
                    setState(() {
                      submitted = true;
                    });
              });
          }
        }
        on SocketException catch (_){
               SharedPreferences.getInstance().then((sp)async{
                     OfflineData offlineData = OfflineData();
                     offlineData.vehicleName = sharedPreferences.get("vehicleName");
                     offlineData.data = jsonEncode(mpPostTripReport);
                      offlineData.formName = "Vehicle Condition Report(Post-trip)";
                      offlineData.userToken = sharedPreferences.get("driverToken");
                      DatabaseHelper helper = DatabaseHelper.instance;
                       int id = await helper.insert(offlineData);
                       print('inserted row: $id');
               });
        }
      }
    });
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          title: Center(
              child: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          content: Text("Your form has been submitted successfully."),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    await SharedPreferences.getInstance().then((sp) {
                      if (sp.get("frontListStart") != null) {
                        sp.setString("frontListStart", null);
                      }
                      if (sp.get("backListStart") != null) {
                        sp.setString("backListStart", null);
                      }
                      if (sp.get("leftListStart") != null) {
                        sp.setString("leftListStart", null);
                      }
                      if (sp.get("rightListStart") != null) {
                        sp.setString("rightListStart", null);
                      }
                      if (sp.get("trailerfrontListStart") != null) {
                        sp.setString("trailerfrontListStart", null);
                      }
                      if (sp.get("trailerleftListStart") != null) {
                        sp.setString("trailerleftListStart", null);
                      }
                      if (sp.get("trailerrightListStart") != null) {
                        sp.setString("frontListStart", null);
                      }
                      if (sp.get("trailerbackListStart") != null) {
                        sp.setString("frontListStart", null);
                      }
                      if (sp.get("front") != null) {
                        sp.setString("front", null);
                      }
                      if (sp.get("back") != null) {
                        sp.setString("back", null);
                      }
                      if (sp.get("left") != null) {
                        sp.setString("left", null);
                      }
                      if (sp.get("right") != null) {
                        sp.setString("right", null);
                      }
                      if (sp.get("frontNose") != null) {
                        sp.setString("frontNose", null);
                      }
                      if (sp.get("rearDoor") != null) {
                        sp.setString("rearDoor", null);
                      }
                      if (sp.get("rightSide") != null) {
                        sp.setString("rightSide", null);
                      }
                      if (sp.get("leftSide") != null) {
                        sp.setString("leftSide", null);
                      }
                      if (sp.get("preTripReport") != null) {
                        sp.setString("preTripReport", null);
                      }
                      if (sp.get("preTripReportNew") != null) {
                        sp.setString("preTripReportNew", null);
                      }
                    });
                    Navigator.popUntil(
                        context, ModalRoute.withName('/vehicle'));
                  },
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
  }

  @override
  void initState() {
    super.initState();
    this._ShowList();
  }

  void _ShowList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String front = prefs.getString("front") != null
        ? prefs.getString("front")
        : prefs.getString("frontListStart");
    String back = prefs.getString("back") != null
        ? prefs.getString("back")
        : prefs.getString("backListStart");
    String left = prefs.getString("left") != null
        ? prefs.getString("left")
        : prefs.getString("leftListStart");
    String right = prefs.getString("right") != null
        ? prefs.getString("right")
        : prefs.getString("rightListStart");

    final jsonFront = await json.decode(front);
    final jsonBack = await json.decode(back);
    final jsonLeft = await json.decode(left);
    final jsonRight = await json.decode(right);

    frontList =
    await jsonFront.map<PreForm>((i) => PreForm.fromJson(i)).toList();
    backList = await jsonBack.map<PreForm>((i) => PreForm.fromJson(i)).toList();
    leftList = await jsonLeft.map<PreForm>((i) => PreForm.fromJson(i)).toList();
    rightList =
    await jsonRight.map<PreForm>((i) => PreForm.fromJson(i)).toList();
    if(prefs.getString("formId") == "preInspection"){
      setState(() {
        driverReport = jsonDecode(prefs.getString("preTripReportNew"));
      });
    }
    else if(prefs.getString("formId") == "postInspection"){
      setState(() {
        driverReport = jsonDecode(prefs.getString("postTripReportNew"));
      });
    }

    previewList.addAll(frontList);
    previewList.addAll(backList);
    previewList.addAll(leftList);
    previewList.addAll(rightList);
    setState(() {
      formId = prefs.get("formId");
      previewLength = (previewList.length.toDouble())*121;
    });
    print("pr length----------->" + previewLength.toString());
  }

  void valueSelected(int value, PreForm preForm) {
    switch (value) {
      case 0:
        preForm.setCheckValue(value);

        setState(() {});
        break;
      case 1:
        preForm.setCheckValue(value);

        setState(() {});
        break;
      case 2:
        preForm.setCheckValue(value);

        setState(() {});
        break;
    }
  }

  Widget listItem(int index, PreForm preformModel, int length) {
    return (Stack(
      children: <Widget>[
        new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          color: Colors.white,
          elevation: 3.0,
          child: new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new SizedBox(
                  height: 3,
                ),
                new Text(preformModel.name,
                    textAlign: TextAlign.start,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                new SizedBox(
                  height: 5,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          IgnorePointer(
                            ignoring: true,
                            child: Radio(
                                value: 0,
                                groupValue: preformModel.check,
                                onChanged: (value) {
                                  valueSelected(value, preformModel);
                                },
                                activeColor: Colors.green),
                          ),
                          Text(
                            "Checked ",
                            style: new TextStyle(fontSize: 13.0),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          IgnorePointer(
                            ignoring: true,
                            child: Radio(
                                value: 1,
                                groupValue: preformModel.check,
                                onChanged: (value) {
                                  valueSelected(value, preformModel);
                                },
                                activeColor: Colors.red),
                          ),
                          Text(
                            "Repair ",
                            style: new TextStyle(fontSize: 13.0),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          IgnorePointer(
                            ignoring: true,
                            child: Radio(
                                value: 2,
                                groupValue: preformModel.check,
                                onChanged: (value) {
                                  valueSelected(value, preformModel);
                                },
                                activeColor: Colors.yellow),
                          ),
                          Text(
                            "N/A",
                            style: new TextStyle(fontSize: 13.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                  preformModel.comment == null ? Text("") :
                  preformModel.comment == "" ? Text("") :
                  Text("Comment : ${preformModel.comment}"),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0076B5),
        title: Text(
          "Preview Page",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
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
                      "Report",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              Container(
                child: driverReport == null? Text(""): Container(
                  height: 310,
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
                        itemCount: driverReport.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: EdgeInsets.only(left: 15.0,top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(driverReport[index].keys.elementAt(0).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                                Text(driverReport[index].values.elementAt(0).toString()),
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
                      "Responses",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              Container(
                  height: previewLength,
                  child: new ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return listItem(
                          index, previewList[index], previewList.length);
                    },
                    itemCount: previewList.length,
                  )),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 80,
                  ),
                  (RaisedButton(
                    textColor: Colors.white,
                    color: Color(0xFF0076B5),
                    child: Text("Edit"),
                    onPressed: () {
                      onEdit();
                    },
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  (RaisedButton(
                    textColor: Colors.white,
                    color: Color(0xFF0076B5),
                    child: Text("Submit"),
                    onPressed: () {
                      setState(() {
                        submitted = false;
                      });
                      _showAlert(context, "ALERT ");
                    },
                  ))
                ],
              )
            ],
          ),
          submitted == true ? Container(
            width: 0.0,
            height: 0.0,
          ):
          Container(
            color: Color.fromRGBO(117, 117, 117, 0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}
