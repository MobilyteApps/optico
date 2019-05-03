import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:compliance/modals/DriverForm.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:compliance/common/list_selection.dart';
import 'package:path/path.dart' as PATH;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';


class InspectionReport extends StatefulWidget {
  final List<DriverForm> allDataBodyPart;
  final List<DriverForm> allDataTrailer;
  final value1;
  InspectionReport({
    Key key,
    this.allDataBodyPart,
    this.allDataTrailer,
    this.value1
  }) : super(key: key);

  @override
  InspectionReportState createState() => InspectionReportState(allDataBodyPart,allDataTrailer,value1);
}


class InspectionReportState extends State<InspectionReport> {
  var value1;
  bool submitted = true;
  final List<DriverForm> allDataBodyPart;
  final List<DriverForm> allDataTrailer;
  InspectionReportState(this.allDataBodyPart,this.allDataTrailer,this.value1);

  ByteData mechanicSign = ByteData(0);
  ByteData driverSign = ByteData(0);
  final _sign = GlobalKey<SignatureState>();
  List<bool> isChecked = [false,false,false];
  final String url = 'http://69.160.84.135:3000/api/users/get-vehicle-bodypart';
  final String urlPost = 'http://69.160.84.135:3000/api/users/driver-road-test';
  final _carrierController = TextEditingController();
  final _locationController = TextEditingController();
  final _tractorTruckNoController = TextEditingController();
  final _odometerBeginController = TextEditingController();
  final _odometerEndController = TextEditingController();
  final _trailerOneController = TextEditingController();
  final _trailerTwoController = TextEditingController();
  final _remarksController = TextEditingController();
  DateTime _date;
  TimeOfDay _time;
  List<DriverForm> finalBodyPartName = List();
  List<DriverForm> finalTrailer = List();
  Map<String, String> header = new Map();
  Dio dio = new Dio();
  FormData formData = new FormData();
  File _imageMechanic;
  File _imageDriver;
  var encodedFinal;
  var vehicleId;


  @override
  void initState() {
    super.initState();
    if(allDataBodyPart != null && allDataTrailer != null) {
      setState(() {
        finalBodyPartName = allDataBodyPart;
        finalTrailer = allDataTrailer;
      });
    }
    else{
      this.getList();
    }
    SharedPreferences.getInstance().then((sp){
      header["Content-Type"] = "multipart/form-data";
      header["Authorization"] = sp.get("driverToken");
      print("driver token ${sp.get("driverToken")}");
      vehicleId = sp
          .get("vehicleId");
    });

  }

  Future<void> submit() async{
    if(_carrierController.text == "" ||
        _locationController.text=="" ||
        _date == null ||
        _time == null ||
        _tractorTruckNoController.text == "" ||
        _odometerBeginController.text == "" ||
    _odometerEndController.text == "" ||
        _trailerOneController.text == "" ||
        _trailerTwoController.text == "" ||
        mechanicSign == null ||
        driverSign == null ||
        _remarksController.text == ""){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            title: Center(
                child: Text(
                  "Alert",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            content: Text(
              "All fields are mandatory.",
              style: TextStyle(fontSize: 15),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
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
    else{
      CircularProgressIndicator();
      _createFileFromString(base64.encode(mechanicSign.buffer.asUint8List()), base64.encode(driverSign.buffer.asUint8List())).then((data){
        List<Map<String, dynamic>> lst1 = new List();
        for (var value in finalBodyPartName) {
          lst1.add(value.toJson());
        }
        List<Map<String, dynamic>> lst2 = new List();
        for (var value in finalTrailer) {
          lst2.add(value.toJson());
        }
        var mpInspectionReport = {
          "Carrier": _carrierController.text,
          "Vehicle Type": vehicleId,
          "Location" : _locationController.text,
          "Vehicle No" : _tractorTruckNoController.text,
          "Odometer Begin" : _odometerBeginController.text,
          "Odometer End" : _odometerEndController.text,
          "Trailer One" : _trailerOneController.text,
          "Trailer Two" : _trailerTwoController.text,
          "Remarks" : _remarksController.text,
          "Date"  : _date.toString(),
          "Time" : _time.toString(),
          "defectOfVehicle" : jsonEncode(lst1),
          "defectOfTrailer" : jsonEncode(lst2),
          "conditonOfTheVehicleIsSatisfactory" : isChecked[0].toString(),
          "aboveDefectsCorrected" : isChecked[1].toString(),
          "aboveDefectsNeedNotBeCorrected" : isChecked[2].toString(),
          "formName" : "Inspection Report"
        };


        FormData formData = new FormData();
        formData.add("mechanicSignature", new UploadFileInfo(_imageMechanic, PATH.basename(_imageMechanic.path)));
        formData.add("driverSignature", new UploadFileInfo(_imageDriver, PATH.basename(_imageDriver.path)));
        formData.addAll(mpInspectionReport);
        if(formData != null){
          dio.post("http://69.160.84.135:3000/api/users/driver-inspection-report", data: formData, options: Options(
            method: 'POST',
            headers: header,
          ))
              .then((response) {
                print("response is ${response.toString()}");

                setState(() {
                  submitted = true;
                });

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  title: Center(
                      child: Text(
                        "Alert",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  content: Text(
                    "Your form has been succesfully submitted.",
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil('/vehicle', (Route<dynamic> route) => false),
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

          })
              .catchError((error) => print("error is ------->>>>> ${error.toString()}"));
        }
      });
    }




  }
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2050));

    if(picked != null && picked != _date){
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);
    if(picked != null && picked != _time){
      setState(() {
        _time = picked;
      });
    }
  }

  Future getList() async{
    http.get(Uri.encodeFull(url)).then((data){
      Map<String, dynamic> allData = json.decode(data.body);
      if(allData.containsKey("bodyPartName") && allData.containsKey("trailer")){
        allData.forEach((key,value){
          if (key == "bodyPartName")
            {
              List bodyPartName = new List();
              value.forEach((val){
                bodyPartName.add({"question": val, "answer":  false});
              });
              setState(() {
                finalBodyPartName = bodyPartName.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();
              });
            }
            if(key == "trailer"){
              List trailer = new List();
              value.forEach((val){
                trailer.add({"question": val, "answer":  false});
              });
              setState(() {
                finalTrailer = trailer.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();
              });
            }
        });
      }
    });
  }

  void valueSelected(var value, DriverForm preForm) {
    preForm.setCheckValue(value);
    setState(() {

    });
  }

  void getSelections(var value){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListSelection(
              allDataBodyPart: finalBodyPartName,
              allDataTrailer: finalTrailer,
              value1: value,
            )),
      );
  }

  Future<Widget> getSignature(var value){
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.width;
   return showDialog(
       context: context,
       builder: (_) => Container(
         color: Colors.white,
         width: width,
         height: height,
         child:
         Column(
           children: <Widget>[
                                 Padding(
                      padding: EdgeInsets.only(top: 15.0,right: 15.0,left: 15.0,bottom: 20.0),
                      child: Container(
                        height: height/1.3,
                        width: width,
                        child: Padding(padding: EdgeInsets.all(6.0),child: Signature(
                          color: Colors.black,
                          key: _sign,
                          onSign: () {
                            final sign = _sign.currentState;
                            debugPrint('${sign.points.length} points in the signature');
                          },

                          strokeWidth: 5.0,
                        ),),

                        color: Colors.black12,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                                color: Color(0xFF0076B5),
                                onPressed: () async {
                                  final sign = _sign.currentState;
                                  //retrieve image data, do whatever you want with it (send to server, save locally...)
                                  final image = await sign.getData();
                                  var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                  sign.clear();
                                  final encoded = base64.encode(data.buffer.asUint8List());
                                  if(value == 1){


                                    setState(() {
                                      mechanicSign = data;
                                    });
                                  }
                                  else {


                                    setState(() {
                                      driverSign = data;
                                    });
                                  }


                                  Navigator.pop(context);
                                  debugPrint("onPressed " + encoded);

                                },
                                child: Text("Save")),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            MaterialButton(
                                color: Colors.grey,
                                onPressed: () {
                                  final sign = _sign.currentState;
                                  sign.clear();
                                  if(value == 1){
                                    setState(() {
                                      mechanicSign = ByteData(0);
                                    });
                                  }
                                  else {
                                    setState(() {
                                      driverSign = ByteData(0);
                                    });
                                  }
                                },
                                child: Text("Clear")),
                          ],
                        ),
                      ],
                    ),
           ],
         ),
       ),
   );
 }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(

        title: Text("Inspection Report",

            textAlign: TextAlign.end, style:
            TextStyle(color: Colors.white)),

        centerTitle: true,

        backgroundColor: Color(0xFF0076B5),

      ),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0,top: 20.0),
                child: Text("Driver's Vehicle Inspection Report",style: TextStyle(fontSize: 20.0,color: Colors.black87,fontWeight: FontWeight.bold),),
              ),

              Padding(
                padding: EdgeInsets.only(left: 15.0,top: 15.0),
                child: Text("As required by the D.O.T Federal Motor Carrier Safety Regulations",style: TextStyle(fontSize: 15.0,),),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Card(

                  margin: EdgeInsets.only(left: 15.0,right: 15.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: TextFormField(
                          controller: _carrierController,
                          decoration: InputDecoration(labelText: "Carrier"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(labelText: "Locations"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: InkWell(
                          onTap: () {
                            if(_date == null){
                              setState(() {
                                _date = DateTime.now();
                              });
                            }
                            _selectDate(context);  // Call Function that has showDatePicker()
                          },
                          child: IgnorePointer(
                            child: _date == null? TextFormField(
                              decoration: new InputDecoration(hintText: 'Date'),
                              // validator: validateDob,
                            ) :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Date"),
                                Text("${_date.month}/${_date.day}/${_date.year}"),
                                Divider(color: Colors.black,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: InkWell(
                          onTap: () {
                            if(_time == null){
                              setState(() {
                                _time = TimeOfDay.now();
                              });
                            }
                            _selectTime(context);  // Call Function that has showDatePicker()
                          },
                          child: IgnorePointer(
                            child: _time == null? TextFormField(
                              decoration: new InputDecoration(hintText: 'Time'),
                            ) :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Time"),
                                _time.hour.toInt() > 12 ? Text("${(_time.hour.toInt())-12}:${_time.minute} ${_time.period.toString().substring(10)}") :
                                _time.hour.toInt() == 0 ? Text("${(_time.hour.toInt())+12}:${_time.minute} ${_time.period.toString().substring(10)}")  :
                                Text("${_time.hour}:${_time.minute} ${_time.period.toString().substring(10)}"),
                                Divider(color: Colors.black,),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _tractorTruckNoController,
                          decoration: InputDecoration(labelText: "Tractor/Truck No",labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
                        child: Text("Odometer Reading",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,),textAlign: TextAlign.start,),
                      ),


                      Padding(
                        padding: EdgeInsets.only(right: 15.0,left: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _odometerBeginController,
                                decoration: InputDecoration(labelText: "Begin"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _odometerEndController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: "End"),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text("Defective Item",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                            Container(
                              width: width,
                              child: Wrap(
                                  spacing: 8.0, // gap between adjacent chips
                                  runSpacing: 4.0, // gap between lines
                                  children: List.generate(finalBodyPartName.length, (i) => finalBodyPartName[i].answer == true ? Chip(label: Text(finalBodyPartName[i].question),
                                    deleteIcon: Icon(Icons.cancel),
                                    labelStyle: TextStyle(color: Color(0xFFE3E3E35) ),
                                    deleteIconColor: Color(0xFF70CCF5),
                                    onDeleted: (){
                                      valueSelected(false, finalBodyPartName[i]);
                                    },
                                  ): Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )).toList()
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                getSelections(1);
                              },
                              child: IgnorePointer(
                                child: Column(
                                  children: <Widget>[
                                    Text(""),
                                    Text(""),
                                    Text(""),
                                    Divider(color: Colors.black,),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
                        child: Text("Trailer Number(S) :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,),textAlign: TextAlign.start,),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 15.0,left: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(prefixText: "1.",prefixStyle: TextStyle(color: Colors.black)),
                                controller: _trailerOneController,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(prefixText: "2.",prefixStyle: TextStyle(color: Colors.black),),
                                controller: _trailerTwoController,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Trailer Defective Item",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),

                            Container(
                              width: width,
                              child: Wrap(
                                  spacing: 8.0, // gap between adjacent chips
                                  runSpacing: 4.0, // gap between lines
                                  children: List.generate(finalTrailer.length, (i) => finalTrailer[i].answer == true ? Chip(label: Text(finalTrailer[i].question),
                                    deleteIcon: Icon(Icons.cancel),
                                    labelStyle: TextStyle(color: Color(0xFFE3E3E35) ),
                                    deleteIconColor: Color(0xFF70CCF5),
                                    onDeleted: (){
                                      valueSelected(false, finalTrailer[i]);
                                    },
                                  ): Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )).toList()
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                getSelections(2);
                              },
                              child: IgnorePointer(
                                child: Column(
                                  children: <Widget>[
                                    Text(""),
                                    Text(""),
                                    Text(""),
                                    Divider(color: Colors.black,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: TextFormField(
                          maxLines: 3,
                          controller: _remarksController,
                          decoration: InputDecoration(labelText: "Remarks",labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: isChecked[0],
                              onChanged: (value) {
                                setState(() {
                                  isChecked[0] = value;
                                });
                              },
                            ),
                            Expanded(
                              child: Text("CONDITION OF THE VEHICLE IS SATISFACTORY",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: isChecked[1],
                              onChanged: (value) {
                                setState(() {
                                  isChecked[1] = value;
                                });
                              },
                            ),
                            Expanded(
                              child: Text("ABOVE DEFECTS CORRECTED",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: isChecked[2],
                              onChanged: (value) {
                                setState(() {
                                  isChecked[2] = value;
                                });
                              },
                            ),
                            Expanded(
                              child: Text("ABOVE DEFECTS NEED  NOT BE CORRECTED FOR SAFE OPERATION OF VEHICLE",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.only(top: 20.0,right: 15.0,left: 15.0),
                        child: Text("Mechanic's Signature",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child:
                        RaisedButton(
                          onPressed: (){getSignature(1);},
                          child: mechanicSign.buffer.lengthInBytes == 0 ? Text("Click") : Container(
                            height: 200.0,
                            width: width,
                            child: Image.memory(mechanicSign.buffer.asUint8List()),
                          ),
                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: Text("Driver's Signature",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child:
                        RaisedButton(
                          onPressed: (){getSignature(2);},
                          child: driverSign.buffer.lengthInBytes == 0 ? Text("Click") : Container(
                            height: 200.0,
                            width: width,
                            child: Image.memory(driverSign.buffer.asUint8List()),
                          ),
                        ),

                      ),

                      Padding(padding: EdgeInsets.only(top: 30.0),),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0,right: 15.0,left: 15.0),
                        child: Container(
                          color: Color(0xFF0076B5),
                          height: 50.0,
                          width: width,
                          child: FlatButton(onPressed: (){
                            setState(() {
                              submitted = false;
                            });
                            submit();

                          }, child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 20.0),),),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 30.0),),
                    ],
                  ),
                ),

              ),

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
      )

    );
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
//    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);
    Future<PermissionStatus> status= PermissionHandler().checkPermissionStatus(permission);

    status.then((data){
      if(data.toString() == "PermissionStatus.denied"){
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0)),
              title: Center(
                  child: Text(
                    "Alert",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              content: Text(
                "Please go to setting and change\nthe permission because it\nis required for the Application\nto proceed.",
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        PermissionHandler().openAppSettings().then((bool hasOpened) =>
                            Navigator.pop(context));
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
    });
  }


  Future<String> _createFileFromString(var value1, var value2) async {

    if(Platform.isIOS){
      Uint8List bytes1 = base64.decode(value1);
      Uint8List bytes2 = base64.decode(value2);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file1 = File(
          "$dir/" + "mechanicSign" + ".png");
      setState(() {
        _imageMechanic = file1;
      });
      File file2 = File(
          "$dir/" + "driverSign" + ".png");
      setState(() {
        _imageDriver = file2;
      });
      await file1.writeAsBytes(bytes1);
      await file2.writeAsBytes(bytes2);
      print("file path ${file1.path}\n${file2.path}");
      return file1.path;
    }
    else{
      PermissionGroup permission = PermissionGroup.storage;
      await requestPermission(permission);

      Uint8List bytes1 = base64.decode(value1);
      Uint8List bytes2 = base64.decode(value2);
      String dir = (await getExternalStorageDirectory()).path;
      File file1 = File(
          "$dir/" + "mechanicSign" + ".png");
      setState(() {
        _imageMechanic = file1;
      });
      File file2 = File(
          "$dir/" + "driverSign" + ".png");
      setState(() {
        _imageDriver = file2;
      });
      await file1.writeAsBytes(bytes1);
      await file2.writeAsBytes(bytes2);
      print("file path ${file1.path}\n${file2.path}");
      return file1.path;
    }


  }

}

