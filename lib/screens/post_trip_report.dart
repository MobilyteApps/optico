  import 'package:flutter/material.dart';

  import 'package:shared_preferences/shared_preferences.dart';
  import 'dart:convert';

  import 'package:intl/intl.dart';







  class PostTripReport
  extends StatefulWidget {

  PostTripReport({Key key}) :
  super(key: key);



  @override

  PostTripReportState
  createState() => PostTripReportState();

  }



  class PostTripReportState
  extends State<PostTripReport> {

  SharedPreferences sharedPreferences;

  final _trailerController =
  TextEditingController();

  final _odometerReadingStopController =
  TextEditingController();


  var driverName;

  var vehicleName;
  var companyName;
  DateTime _date;
  TimeOfDay _time;



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
      print("date selected : ${_date.toString()}" );
      setState(() {
        _date = picked;
      });
    }
  }




  @override

  void initState() {

  super.initState();

  SharedPreferences.getInstance().then((sp) {

    if(sp.get("postTripReportNew") != null){



      var previousData = jsonDecode(sp.get("postTripReportNew"));


      previousData.forEach((val){
        if(val.containsKey("date")){
          val.forEach((k,v){
            String dateWithT = v.substring(0, 10);
            DateTime dateTime = DateTime.parse(dateWithT);
            setState(() {
              _date = dateTime;
            });
          });
        }
        if(val.containsKey("time")){
          val.forEach((k,v){
            String s = v.substring(10, 15);
            TimeOfDay time = TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1]));
            setState(() {
              _time = time;
            });
          });
        }
        if(val.containsKey("trailer")){
          val.forEach((k,v){
            setState(() {
              _trailerController.text = v;
            });
          });
        }
        if(val.containsKey("odometerReading")){
          val.forEach((k,v){
            setState(() {
              _odometerReadingStopController.text = v;
            });
          });
        }
      });
    }

   vehicleName = sp.get("vehicleName");

  setState(() {

  driverName = sp.get("fullName");
  companyName = sp.get("companyName");

  });

  });

  }


  void part_one() {

    if(driverName == null || companyName==null || _date == null || _time == null || _trailerController.text == "" || _odometerReadingStopController.text == ""){
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
      List<dynamic> ls =
      new List();

      SharedPreferences.getInstance().then((sp) {

        sharedPreferences = sp;

        ls.add({"driverName": driverName});

        ls.add({"Companyname": companyName});

        ls.add({"date" : _date.toString()});
        ls.add({"time" : _time.toString()});

        ls.add({"trailer": _trailerController.text});

        ls.add({"odometerReading": _odometerReadingStopController.text});

        sharedPreferences.setString("postTripReport", ls.toString());
        sharedPreferences.setString("postTripReportNew", jsonEncode(ls));

        print("road test form is ${sharedPreferences.get("postTripReport")}");

        if(vehicleName == "Armored"){
          Navigator.pushNamed(context,
              '/armoured_parts_selection');
        }
        else{
          Navigator.pushNamed(context,
              '/parts_selection');
        }
      });
    }



  }



  @override

  Widget build(BuildContext context) {

  double height =
  MediaQuery.of(context).size.height;

  double width =
  MediaQuery.of(context).size.width;

  return Scaffold(

  appBar: AppBar(

  leading: GestureDetector(

    onTap: () async{
      await SharedPreferences.getInstance().then((sp){
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
        if (sp.get("postTripReport") != null) {
          sp.setString("postTripReport", null);
        }
        if (sp.get("postTripReportNew") != null) {
          sp.setString("postTripReportNew", null);
        }
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/vehicle_selection', (Route<dynamic> route) => false);
    },

  child: Icon(Icons.arrow_back),

  ),

  title: Text("Post Trip Report",

  textAlign: TextAlign.end, style:
  TextStyle(color: Colors.white)),

  centerTitle: true,

    backgroundColor: Color(0xFF0076B5),

  elevation: 0.0,

  ),

  body: new Container(

  padding: new
  EdgeInsets.symmetric(horizontal:
  30.0),

    color: Color(0xFFE3E3E3),

  height: MediaQuery.of(context).size.height,

  child: ListView(

  children: <Widget>[

  SizedBox(

  height: height / 25,

  ),

  SizedBox(

  height: 10,

  ),

  SizedBox(

  height: 15,

  ),

  Card(

  elevation: 10.0,

  child: Container(

  margin: new EdgeInsets.fromLTRB(

  width / 20, height /
  32, width / 20, height /
  32),

  child: Column(

  crossAxisAlignment: CrossAxisAlignment.start,

  children: <Widget>[

  Row(

  children: <Widget>[

  Text(

  "Driver Name :",

  style: TextStyle(

  fontWeight: FontWeight.bold, fontSize:
  16),

  ),

  Text(

  "$driverName",

  style: TextStyle(fontSize:
  16),

  ),

  ],

  ),


  SizedBox(

  height: 20,

  ),
  Text(

    "Company Name :",

    style: TextStyle(

        fontWeight: FontWeight.bold, fontSize:
    16),

  ),

  Text(

    "$companyName",

    style: TextStyle(fontSize:
    16),

  ),
  SizedBox(

    height: 20,

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
        decoration: new InputDecoration(hintText: 'Date',hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        // validator: validateDob,
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
    height: 20,
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
        decoration: new InputDecoration(hintText: 'Time',hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        // validator: validateDob,
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

    height: 20,

  ),

  TextFormField(

    keyboardType: TextInputType.number,

  controller: _trailerController,

  decoration: InputDecoration(

  labelText: "Trailer Number: ",

  labelStyle: new
  TextStyle(

  color: Colors.black,

  fontWeight: FontWeight.bold)),

  ),

  TextFormField(
    keyboardType: TextInputType.number,

    controller: _odometerReadingStopController,

    decoration: InputDecoration(

        labelText: "Odometer Reading (Stop):",

        labelStyle: new
        TextStyle(

            color: Colors.black,

            fontWeight: FontWeight.bold)),

  ),


  SizedBox(

  height: 30,

  ),

  ],

  ),

  ),

  )

  ],

  ),

  ),

  floatingActionButton: FloatingActionButton(

    backgroundColor: Color(0xFF0076B5),

  onPressed: part_one,

  tooltip: 'Next',

  child: Icon(Icons.arrow_right),

  ),

  );

  }

  }