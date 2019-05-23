import 'dart:async';

import 'package:flutter/material.dart';
import 'package:compliance/modals/PreForm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OfflineVehicleConditionReport extends StatefulWidget {
  final data;
  OfflineVehicleConditionReport({Key key, this.data})
      : super(
    key: key,
  );
  @override
  _OfflineVehicleConditionReportState createState() => _OfflineVehicleConditionReportState(data);
}

class _OfflineVehicleConditionReportState extends State<OfflineVehicleConditionReport> {
  var data;
  _OfflineVehicleConditionReportState(this.data);
  List<PreForm> previewList = [];
  List<PreForm> previewList1 = [];
  var driverReport;

  Map<String, dynamic>postTripReportNew;
  double previewLength = 3370;

  String formId;
  String vehicleId;

  @override
  void initState() {
    super.initState();
    var x = jsonDecode(data["defectiveParts"]);
    var y = jsonDecode(data["Report"]);
    setState(() {
      driverReport = y;
    });
    _ShowList(x).then((_){
//      print(previewList1.length.toString());
      setState(() {
        previewList = previewList1;
      });
      setState(() {
        previewLength = (previewList.length.toDouble())*92;
      });

      print(previewList.length.toString());
    });
  }


  Future _ShowList(var x) async {
    var ls;
    x.forEach((m,n) async {
      ls = await n.map<PreForm>((i) => PreForm.fromJson(i)).toList();
      previewList1.addAll(ls);
    });
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
                Text(
                  preformModel.check == 0?"Checked":preformModel.check == 1?"Repair":"N/A",
                    textAlign: TextAlign.start,
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                ),
//                preformModel.check == 0 ? Text(("Checked")) : preformModel.check == 1 ? Text("")
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
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0076B5),
        centerTitle: true,
        title: Text(
          "Offline Vehicle Condition Report",
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
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return listItem(
                      index, previewList[index], previewList.length);
                },
                itemCount: previewList.length,
              )),
        ],
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
//    return Scaffold(
//      appBar: AppBar(
//        automaticallyImplyLeading: false,
//        backgroundColor: Color(0xFF0076B5),
//        centerTitle: true,
//        title: Text(
//          "Offline Preview Page",
//          style: TextStyle(color: Colors.white, fontSize: 20),
//        ),
//      ),
//      body: Stack(
//        children: <Widget>[
//          ListView(
//            children: <Widget>[
//              Container(
//                height: 50.0,
//                width: width,
//                color: Colors.grey[300],
//                child: Padding(
//                  padding: EdgeInsets.only(left: 20.0, right: 5.0),
//                  child: Align(
//                    alignment: Alignment.centerLeft,
//                    child: Text(
//                      "Report",
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 20),
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                child: driverReport == null? Text(""): Container(
//                  height: 310,
//                  child: Card(
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(8),
//                    ),
//                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                    color: Colors.white,
//                    elevation: 3.0,
//                    child: ListView.builder(
//                        physics: NeverScrollableScrollPhysics(),
//                        shrinkWrap: true,
//                        itemCount: driverReport.length,
//                        itemBuilder: (BuildContext context, int index){
//                          return Padding(
//                            padding: EdgeInsets.only(left: 15.0,top: 10.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(driverReport[index].keys.elementAt(0).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
//                                Text(driverReport[index].values.elementAt(0).toString()),
//                              ],
//                            ),
//                          );
//                        }
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                height: 50.0,
//                width: width,
//                color: Colors.grey[300],
//                child: Padding(
//                  padding: EdgeInsets.only(left: 20.0, right: 5.0),
//                  child: Align(
//                    alignment: Alignment.centerLeft,
//                    child: Text(
//                      "Responses",
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 20),
//                    ),
//                  ),
//                ),
//              ),
//              Container(
//                  height: previewLength,
//                  child: new ListView.builder(
//                    shrinkWrap: true,
//                    physics: NeverScrollableScrollPhysics(),
//                    itemBuilder: (BuildContext context, int index) {
//                      return listItem(
//                          index, previewList[index], previewList.length);
//                    },
//                    itemCount: previewList.length,
//                  )),
//        ],
//      ),
//  ]
//    )
//    );}
}
