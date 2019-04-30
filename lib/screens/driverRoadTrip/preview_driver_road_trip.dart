import 'dart:async';
import 'package:flutter/material.dart';
import 'package:compliance/modals/PreForm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/DriverForm.dart';
import 'package:compliance/modals/NewDriverForm.dart';

class PreviewDriverRoadTrip extends StatefulWidget {
  @override
  _PreviewDriverRoadTripState createState() => _PreviewDriverRoadTripState();
}

class _PreviewDriverRoadTripState extends State<PreviewDriverRoadTrip> {
  List<DriverForm> finalPreTripInspectionList = List();
  Map<dynamic, dynamic> placingTheVehicleInMotionMap = Map();
  NewDriverForm newDriverFormPlacingTheVehicleInMotion;
  List<DriverForm> finalCouplingAndUncouplingList = List();
  NewDriverForm newDriverFormBackingAndParking;
  Map<dynamic, dynamic> backingAndParkingMap = Map();
  var driverRoadTestForm;
  List<Widget> li1 = new List();
  List<Widget> li2 = new List();
  List<List<Widget>> finalList = List();

  
  SharedPreferences sharedPreferences;
 
  var dataTOSend = {};

  String url = "http://69.160.84.135:3000/api/users/driver-road-test";

  String formId;

  Future _showAlert(BuildContext context, String message) async {
    SharedPreferences.getInstance().then((sp) async {
      sharedPreferences = sp;
      Map<String, String> header = new Map();
      header["Content-Type"] = "application/x-www-form-urlencoded";
      header["Authorization"] = sharedPreferences.get("driverToken");
      if (formId == "driverRoadTrip") {
        var mpDriverRoadTrip = {
          "vehicleType": jsonEncode(sharedPreferences.get("vehicleId")),
          "Report" : sharedPreferences .get("driverRoadTestFormNew"),
          "PRE-TRIP INSPECTION": sharedPreferences.get("finalPreTripInspectionData"),
          "PLACING THE VEHICLE IN MOTION" : sharedPreferences.get("finalPlacingTheVehicleInMotion"),
          "COUPLING AND UNCOUPLING" : sharedPreferences.get("finalCouplingAndUncouplingList"),
          "BACKING AND PARKING" : sharedPreferences.get("finalBackingAndParking"),
          "formName" : jsonEncode("Driver Road Test Form")
        };

        var v = await http.post(
            "http://69.160.84.135:3000/api/users/driver-road-test",
            body: mpDriverRoadTrip ,
            headers: header);
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
          content: Text("Form submitted successfuly"),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    await SharedPreferences.getInstance().then((sp){
                      sharedPreferences = sp;
                      if (sharedPreferences.get("finalPreTripInspectionData") != null) {
                        sharedPreferences.setString("finalPreTripInspectionData", null);
                      }
                      if (sharedPreferences.get("finalPlacingTheVehicleInMotion") != null) {
                        sharedPreferences.setString("finalPlacingTheVehicleInMotion", null);
                      }
                      if (sharedPreferences.get("finalCouplingAndUncouplingList") != null) {
                        sharedPreferences.setString("finalCouplingAndUncouplingList", null);
                      }
                      if (sharedPreferences.get("finalBackingAndParking") != null) {
                        sharedPreferences.setString("finalBackingAndParking", null);
                      }
                      if (sp.get("driverRoadTestForm") != null) {
                        sp.setString("driverRoadTestForm", null);
                      }
                      if (sp.get("driverRoadTestFormNew") != null) {
                        sp.setString("driverRoadTestFormNew", null);
                      }
                    });
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/vehicle', (Route<dynamic> route) => false);
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
    this._showList();
  }

  void _showList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.get("driverRoadTestFormNew") != null){
      final jsonCoup = json.decode(prefs.get("driverRoadTestFormNew"));
      setState(() {
        driverRoadTestForm = jsonCoup;
      });
    }

    if (prefs.get("finalPreTripInspectionData") != null) {
          List<DriverForm> couplingList1;
          final jsonCoup = json.decode(prefs.get("finalPreTripInspectionData"));
          
          couplingList1 =
              jsonCoup.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();  
          setState(() {
            finalPreTripInspectionList = couplingList1;
          });
      }
      if(prefs.get("finalPlacingTheVehicleInMotion") != null){
        setState(() {
        placingTheVehicleInMotionMap =
            jsonDecode(prefs.get("finalPlacingTheVehicleInMotion"));
      });
       newDriverFormPlacingTheVehicleInMotion = new NewDriverForm.fromJson(placingTheVehicleInMotionMap);
      }
      if (prefs.get("finalCouplingAndUncouplingList") != null) {
          List<DriverForm> couplingList1;
          final jsonCoup = json.decode(prefs.get("finalCouplingAndUncouplingList"));
          if(jsonCoup!=null){
            print("jsonCoup-----> ${jsonCoup.toString()}");
          }
          
          couplingList1 =
              jsonCoup.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();  
          setState(() {
            finalCouplingAndUncouplingList = couplingList1;
          });
      }
      if(prefs.get("finalBackingAndParking") != null){
        setState(() {
        backingAndParkingMap =
            jsonDecode(prefs.get("finalBackingAndParking"));
      });
       newDriverFormBackingAndParking = new NewDriverForm.fromJson(backingAndParkingMap);
      }
    setState(() {
      formId = prefs.get("formId");
    });
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
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IgnorePointer(
                              ignoring: true,
                              child: Radio(
                                  value: 0,
                                  groupValue: preformModel.check,
                                  // onChanged: (value) {
                                  //   valueSlected(value, preformModel);
                                  // },
                                  activeColor: Colors.green),
                            ),
                            Text(
                              "Checked",
                              style: new TextStyle(fontSize: 15.0),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IgnorePointer(
                              ignoring: true,
                              child: Radio(
                                  value: 1,
                                  groupValue: preformModel.check,
                                  // onChanged: (value) {
                                  //   valueSlected(value, preformModel);
                                  // },
                                  activeColor: Colors.red),
                            ),
                            Text(
                              "Repair",
                              style: new TextStyle(fontSize: 15.0),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            IgnorePointer(
                              ignoring: true,
                              child: Radio(
                                  value: 2,
                                  groupValue: preformModel.check,
                                  // onChanged: (value) {
                                  //   valueSlected(value, preformModel);
                                  // },
                                  activeColor: Colors.yellow),
                            ),
                            Text(
                              "N/A",
                              style: new TextStyle(fontSize: 15.0),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget printQuestions2(){
    if(newDriverFormBackingAndParking != null){
      for(var i = 0; i<newDriverFormBackingAndParking.dataList.length;i++){
        li2.add(
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${newDriverFormBackingAndParking.dataList[i].title} :",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:
                    newDriverFormBackingAndParking.dataList[i].questionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.fromLTRB(15, 5, 10, 5),
                    color: Colors.white,
                    elevation: 3.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "${newDriverFormBackingAndParking.dataList[i].questionList[index].question}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    // onChanged: (val) {
                                    //   valueSlected(val, i,index);
                                       
                                    // },
                                    activeColor: Colors.green,
                                    value: 0,
                                     groupValue: newDriverFormBackingAndParking.dataList[i].questionList[index].answer,
                                  ),
                                  Text(
                                    "Checked",
                                    style: new TextStyle(fontSize: 15.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    // onChanged: (val) {
                                    //  valueSlected(val, i,index);
                                    // },
                                    activeColor: Colors.red,
                                    value: 1,
                                    groupValue: newDriverFormBackingAndParking.dataList[i].questionList[index].answer,
                                  ),
                                  Text(
                                    "Repair",
                                    style: new TextStyle(fontSize: 15.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    // onChanged: (val) {
                                    //   valueSlected(val, i,index);
                                    // },
                                    activeColor: Colors.yellow,
                                    value: 2,
                                    groupValue: newDriverFormBackingAndParking.dataList[i].questionList[index].answer,
                                  ),
                                  Text(
                                    "N/A",
                                    style: new TextStyle(fontSize: 15.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        newDriverFormBackingAndParking.dataList[i].questionList[index].comment == null ? Text("") :
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
                            child: GestureDetector(
                              onTap: null,
                              child: Text("Comment : ${newDriverFormBackingAndParking.dataList[i].questionList[index].comment}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          )
        );
      }
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: li2.length,
        itemBuilder: (BuildContext context, int index) {
          return li2[index];
        },
      );
    }
    else{
      return Text("");
    }
  }

  Widget printQuestions1(){
    if(newDriverFormPlacingTheVehicleInMotion != null){
      for(var i = 0; i<newDriverFormPlacingTheVehicleInMotion.dataList.length;i++){
        li1.add(
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${newDriverFormPlacingTheVehicleInMotion.dataList[i].title} :",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:
                    newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.fromLTRB(15, 5, 10, 5),
                    color: Colors.white,
                    elevation: 3.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "${newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].question}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    // onChanged: (val) {
                                    //   valueSlected2(val, i,index);
                                       
                                    // },
                                    activeColor: Colors.green,
                                    value: 0,
                                     groupValue: newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].answer,
                                  ),
                                  Text(
                                    "Checked",
                                    style: new TextStyle(fontSize: 15.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    // onChanged: (val) {
                                    //  valueSlected2(val, i,index);
                                    // },
                                    activeColor: Colors.red,
                                    value: 1,
                                    groupValue: newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].answer,
                                  ),
                                  Text(
                                    "Repair",
                                    style: new TextStyle(fontSize: 15.0),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                    // onChanged: (val) {
                                    //   valueSlected2(val, i,index);
                                    // },
                                    activeColor: Colors.yellow,
                                    value: 2,
                                    groupValue: newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].answer,
                                  ),
                                  Text(
                                    "N/A",
                                    style: new TextStyle(fontSize: 15.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].comment == null ? Text("") :
                        newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].comment == "" ? Text("") :
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
                            child: GestureDetector(
                              onTap: null,
                              child: Text("Comment : ${newDriverFormPlacingTheVehicleInMotion.dataList[i].questionList[index].comment}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          )
        );
      }
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: li1.length,
        itemBuilder: (BuildContext context, int index) {
          return li1[index];
        },
      );
    }
    else{
      return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0076B5),
        title: Text(
          "Preview Page",
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
              child: driverRoadTestForm == null? Text(""): Container(
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
                      itemCount: driverRoadTestForm.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: EdgeInsets.only(left: 15.0,top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(driverRoadTestForm[index].keys.elementAt(0).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                              Text(driverRoadTestForm[index].values.elementAt(0).toString()),
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
          child: finalPreTripInspectionList == null? Text("") : Container(
            height: 1000,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              itemCount: finalPreTripInspectionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  color: Colors.white,
                  elevation: 3.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(finalPreTripInspectionList[index].question,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      new SizedBox(
                        height: 5,
                      ),
                      Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(

                              children: <Widget>[
                                Radio(
                                  // onChanged: (val) {
                                  //   valueSlected1(val, finalPreTripInspectionList[index]);
                                  // },
                                  activeColor: Colors.green,
                                  value: 0,
                                  groupValue: finalPreTripInspectionList[index].answer,
                                ),
                                Text(
                                  "Checked",
                                  style: new TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  // onChanged: (val) {
                                  //   valueSlected1(val, finalPreTripInspectionList[index]);
                                  // },
                                  activeColor: Colors.red,
                                  value: 1,
                                  groupValue: finalPreTripInspectionList[index].answer,
                                ),
                                Text(
                                  "Repair",
                                  style: new TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  // onChanged: (val) {
                                  //   valueSlected1(val, finalPreTripInspectionList[index]);
                                  // },
                                  activeColor: Colors.yellow,
                                  value: 2,
                                  groupValue: finalPreTripInspectionList[index].answer,
                                ),
                                Text(
                                  "N/A",
                                  style: new TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      finalPreTripInspectionList[index].comment == null ? Text("") :
                      Padding(
                        padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
                        child: GestureDetector(
                          onTap: null,
                          child: Text("Comment : ${finalPreTripInspectionList[index].comment}"),
                        ),
                      ),
                    ],
                  ),

                );
              },
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
            height: 2100,
            child: printQuestions1(),
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
          child: finalCouplingAndUncouplingList == null? Text("") : Container(
            height: 1000,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: finalCouplingAndUncouplingList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  color: Colors.white,
                  elevation: 3.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(finalCouplingAndUncouplingList[index].question,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      new SizedBox(
                        height: 5,
                      ),
                      Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(

                              children: <Widget>[
                                Radio(
                                  // onChanged: (val) {
                                  //   valueSlected(val, finalCouplingAndUncouplingList[index]);
                                  // },
                                  activeColor: Colors.green,
                                  value: 0,
                                  groupValue: finalCouplingAndUncouplingList[index].answer,
                                ),
                                Text(
                                  "Checked",
                                  style: new TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  // onChanged: (val) {
                                  //   valueSlected(val, finalCouplingAndUncouplingList[index]);
                                  // },
                                  activeColor: Colors.red,
                                  value: 1,
                                  groupValue: finalCouplingAndUncouplingList[index].answer,
                                ),
                                Text(
                                  "Repair",
                                  style: new TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  // onChanged: (val) {
                                  //   valueSlected(val, finalCouplingAndUncouplingList[index]);
                                  // },
                                  activeColor: Colors.yellow,
                                  value: 2,
                                  groupValue: finalCouplingAndUncouplingList[index].answer,
                                ),
                                Text(
                                  "N/A",
                                  style: new TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      finalCouplingAndUncouplingList[index].comment == null ? Text("") :
                      Padding(
                        padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
                        child: GestureDetector(
                          onTap: null,
                          child: Text("Comment : ${finalCouplingAndUncouplingList[index].comment}"),
                        ),
                      ),
                    ],
                  ),

                );
              },
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
              height: 1700,
              child: printQuestions2(),
            ),
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
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/driver_form', (Route<dynamic> route) => false);
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
                      _showAlert(context, "ALERT ");
                    },
                  ))
                ],
              )
        ],
      ), 
          
    );
  }
}
