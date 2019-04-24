import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class DriverForm extends StatefulWidget {
  DriverForm({Key key}) : super(key: key);

  @override
  _DriverFormState createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final String url =
      'http://10.10.30.73:3000/api/users/driver-road-test/driver-road-test';

  List<dynamic>  preTripInspection = List();
  List<dynamic>  couplingAndUnCoupling = List();
  Map<String,dynamic> placingTheVehicleInMotion = Map();
  Map<String,dynamic> backingAndParking = Map();

  TextEditingController _startingMilesController;
  TextEditingController _endingMilesController;

  var driverName;
  var address;
  var license;
  var vehicleName;
  var equipmentDriven;
  var startingMiles;
  var endingMiles;
  var milesDriven;
  DateTime _date;
  TimeOfDay _time;


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {

      if(sp.get("driverRoadTestFormNew") != null){

        var previousData = jsonDecode(sp.get("driverRoadTestFormNew"));

        previousData.forEach((val){
          if(val.containsKey("Date")){
            val.forEach((k,v){


              String dateWithT = v.substring(0, 10);
              DateTime dateTime = DateTime.parse(dateWithT);

              setState(() {
                _date = dateTime;
              });
            });
          }
          if(val.containsKey("Time")){
            val.forEach((k,v){
              String s = v.substring(10, 15);
              TimeOfDay time = TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1]));
              setState(() {
                _time = time;
              });
            });
          }
          if(val.containsKey("Start Miles")){
            val.forEach((k,v){
              _startingMilesController = TextEditingController(text : v);
            });
          }
          if(val.containsKey("End Miles")){
            val.forEach((k,v){
              _endingMilesController = TextEditingController(text : v);
            });
          }
          if(val.containsKey("Miles Driven")){
            val.forEach((k,v){
              setState(() {
                milesDriven = int.parse(v);
              });
            });
          }
        });
      }
      else{
        _startingMilesController = TextEditingController();
        _endingMilesController = TextEditingController();
      }
      setState(() {
        driverName = sp.get("fullName");
        address = sp.get("address");
        license = sp.get("license");
        equipmentDriven = sp.get("vehicleId");
        vehicleName = sp.get("vehicleName");
      });
    });
  }

  void totalMiles(var start, var end) {
    
    var myStarting = int.parse(start);
    var myEnding = int.parse(end);

    assert(myStarting is int);
    assert(myEnding is int);
    var total = myEnding - myStarting;
    setState(() {
      milesDriven = total;
    });
  }


  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);
    if(picked != null && picked != _time){
      setState(() {
        _time = picked;
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

  // ignore: missing_return
  Future<void> goToPreTrip() {
    if(driverName == null || milesDriven==null || _date == null || _time == null || _startingMilesController.text == "" || _endingMilesController.text == ""){
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
      List<dynamic> ls = new List();
      SharedPreferences.getInstance().then((sp) {
        ls.add({"Driver Name": driverName});
        ls.add({"Address": address});
        ls.add({"License": license});
        ls.add({"Equipment Driven": equipmentDriven});
        ls.add({"Date" : _date.toString()});
        ls.add({"Time" : _time.toString()});
        ls.add({"Start Miles": _startingMilesController.text});
        ls.add({"End Miles": _endingMilesController.text});
        ls.add({"Miles Driven": milesDriven.toString()});
        sp.setString("driverRoadTestForm", ls.toString());
        sp.setString("driverRoadTestFormNew", jsonEncode(ls));
        if(sp.get("formId") == "driverRoadTrip"){
          getAllForms();
        }
      });
    }


  }

  Future getAllForms() async{
    http.get(Uri.encodeFull(url)).then((data){
      Map<String, dynamic> mp = json.decode(data.body);
      if(mp.containsKey("data")){
        mp.forEach((k,v){
          if(k=="data"){
            v.forEach((m){
              Map<dynamic,dynamic> mp1 = m;
              if(mp1.containsValue("PRE-TRIP INSPECTION")){
                mp1.forEach((x,y){
                  if(x == "questionary"){
                    preTripInspection = y;
                  }
                });
              }
              else if(mp1.containsValue("PLACING THE VEHICLE IN MOTION")){
                List<dynamic>  placingTheVehicleInList = List();
                var key;
                mp1.forEach((x,y){
                  if(x == "bodyparts"){
                    key = y;
                  }
                  else if(x == "questionary"){
                    placingTheVehicleInList = y;
                  }
                });
                placingTheVehicleInMotion[key] = placingTheVehicleInList;
                
              }
              else if(mp1.containsValue("COUPLING AND UNCOUPLING")){
                mp1.forEach((x,y){
                  if(x == "questionary"){
                    couplingAndUnCoupling = y;
                  }
                });
              }
              else if(mp1.containsValue("BACKING AND PARKING")){
                List<dynamic>  placingTheVehicleInList = List();
                var key;
                mp1.forEach((x,y){
                  if(x == "bodyparts"){
                    key = y;
                  }
                  else if(x == "questionary"){
                    placingTheVehicleInList = y;
                  }
                });
                backingAndParking[key] = placingTheVehicleInList;
                
              }
            });
          }
        });
      }
      SharedPreferences.getInstance().then((sp){
        sp.setString("preTripInspection", jsonEncode(preTripInspection));
        sp.setString("couplingAndUnCoupling", jsonEncode(couplingAndUnCoupling));
        sp.setString("backingAndParking", jsonEncode(backingAndParking));
        sp.setString("placingTheVehicleInMotion", jsonEncode(placingTheVehicleInMotion));
        Navigator.pushNamed(context, '/pre_trip_inspection');
      }); 
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async{
            await SharedPreferences.getInstance().then((sp){
              if (sp.get("finalPreTripInspectionData") != null) {
                sp.setString("finalPreTripInspectionData", null);
              }
              if (sp.get("finalPlacingTheVehicleInMotion") != null) {
                sp.setString("finalPlacingTheVehicleInMotion", null);
              }
              if (sp.get("finalCouplingAndUncouplingList") != null) {
                sp.setString("finalCouplingAndUncouplingList", null);
              }
              if (sp.get("finalBackingAndParking") != null) {
                sp.setString("finalBackingAndParking", null);
              }
              if (sp.get("driverRoadTestForm") != null) {
                sp.setString("driverRoadTestForm", null);
              }
              if (sp.get("driverRoadTestFormNew") != null) {
                sp.setString("driverRoadTestFormNew", null);
              }
            });
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/vehicle_selection', (Route<dynamic> route) => false);
          },
          child: Icon(Icons.arrow_back),
        ),

        title: Text('Drivers Road Test',
            textAlign: TextAlign.end, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF0076B5),
        elevation: 0.0,
      ),
      body: new Container(
        padding: new EdgeInsets.symmetric(horizontal: 30.0),
        color: Color(0xFFE3E3E3),
        height: MediaQuery.of(context).size.height,
    
        child: ListView(
        
          children: <Widget>[

           
            SizedBox(
              height: 15,
            ),
            Card(
              margin: EdgeInsets.only(bottom: 10.0,top: 0.0,left: 5.0,right: 5.0),

              elevation: 10.0,
              child: Container(
                margin: new EdgeInsets.only(bottom: 30.0,top: 20.0,left: 15.0,right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Driver Name :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "$driverName",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Address :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "$address",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Driver License :",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "$license",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                          "Equipment Driven :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "$vehicleName",
                          style: TextStyle(fontSize: 16),
                        ),
                   
                    SizedBox(
                      height: 15,
                    ),

                    InkWell(
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
                        ) :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                            Text("${_date.month}/${_date.day}/${_date.year}"),
                            Divider(color: Colors.black,),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    InkWell(
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
                            Text("Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                            _time.hour.toInt() > 12 ? Text("${(_time.hour.toInt())-12}:${_time.minute} ${_time.period.toString().substring(10)}") :
                            _time.hour.toInt() == 0 ? Text("${(_time.hour.toInt())+12}:${_time.minute} ${_time.period.toString().substring(10)}")  :
                            Text("${_time.hour}:${_time.minute} ${_time.period.toString().substring(10)}"),
                            Divider(color: Colors.black,),
                          ],
                        ),
                      ),
                    ),
                    
                   
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _startingMilesController,
                      decoration: InputDecoration(
                          labelText: "Starting miles :",
                          labelStyle: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _endingMilesController,
                      decoration: InputDecoration(
                          labelText: "Ending miles : ",
                          labelStyle: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                          "Miles driven :",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                     GestureDetector(
                                onTap: () {
                                  totalMiles(_startingMilesController.text,
                                      _endingMilesController.text);
                                },
                                child: milesDriven == null ? Container(
                                  width: width,
                                  decoration: BoxDecoration(border: BorderDirectional(bottom:  BorderSide(color: Colors.black))),
                                  child: Text(""),
                                ) : milesDriven < 0 ? Container(
                                  width: width,
                                  decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.black))),
                                  child: Text("Ending Miles should be greater then Starting Miles!",style: TextStyle(color: Colors.red),),
                                ) : Container(
                                  width: width,
                                  decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.black))),
                                  child: Text("${milesDriven.toString()}",style: TextStyle(fontSize: 16.0),),
                                ),
                               
                              ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        onPressed: goToPreTrip,
        tooltip: 'Next',
        child: Icon(Icons.arrow_right),
      ),
    );
  }
}
