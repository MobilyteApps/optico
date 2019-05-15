import 'dart:async';
import 'package:flutter/material.dart';
import 'package:compliance/screens/partsScreens/back_screen.dart';
import 'package:compliance/screens/partsScreens/right_screen.dart';
import 'package:compliance/screens/partsScreens/left_screen.dart';
import 'package:compliance/screens/partsScreens/front_nose.dart';
import 'package:compliance/screens/partsScreens/rear_door.dart';
import 'package:compliance/screens/partsScreens/front_screen.dart';
import 'package:compliance/screens/partsScreens/leftSide_screen.dart';
import 'package:compliance/screens/partsScreens/rightSide_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/PreForm.dart';

class QuestionsScreen extends StatefulWidget {
  final List<PreForm> backList;
  final List<PreForm> frontList;
  final List<PreForm> rightList;
  final List<PreForm> leftList;
  final List<PreForm> trailerRightList;
  final List<PreForm> trailerLeftList;
  final List<PreForm> trailerFrontList;
  final List<PreForm> trailerBackList;
  final indexPage;
  QuestionsScreen({
    Key key,
    this.backList,
    this.frontList,
    this.rightList,
    this.leftList,
    this.trailerBackList,
    this.trailerFrontList,
    this.trailerLeftList,
    this.trailerRightList,
    this.indexPage
  })
      : super(
    key: key,
  );

  @override
  QuestionsScreenState createState() => QuestionsScreenState(backList,frontList,rightList,leftList,trailerRightList,trailerFrontList,trailerLeftList,trailerBackList,this.indexPage);
}

class QuestionsScreenState extends State<QuestionsScreen> {

  List<PreForm> backList;
  List<PreForm> frontList;
  List<PreForm> rightList;
  List<PreForm> leftList;
  List<PreForm> trailerRightList;
  List<PreForm> trailerLeftList;
  List<PreForm> trailerFrontList;
  List<PreForm> trailerBackList;
  ScrollController firstScroll = ScrollController();
  ScrollController  _scrollController = new ScrollController();
  var indexPage ;
  QuestionsScreenState(this.backList,this.frontList,this.rightList,this.leftList,this.trailerRightList,this.trailerFrontList,this.trailerLeftList,this.trailerBackList,this.indexPage);

  SharedPreferences sharedPreferences;
  double _ITEM_WIDTH = 100.0;

  List options = [
    "Front",
    "Back",
    "Left",
    "Right",
    "Trailer Front",
    "Trailer Back",
    "Trailer Left",
    "Trailer Right",
  ];

  Map<String,bool> checkOptions = {
    "Front":false,
    "Back":false,
    "Left":false,
    "Right":false,
    "Trailer Front":false,
    "Trailer Back":false,
    "Trailer Left":false,
    "Trailer Right":false,
  };

  @override
  void initState() {
    super.initState();

    firstScroll.addListener((){
      _scrollController.animateTo(indexPage * 100.0, duration: new Duration(seconds: 2), curve: Curves.ease);
    });


  }

  Future checkRadioOption() async {
    bool allValueChecked = true;

    if(indexPage == 0){
      for (var value in frontList) {
        if(value.check == -1){
          allValueChecked = false;
          break;
        }
      }
      if(allValueChecked){
        checkOptions["Front"] = true;
      }
      setState(() {

      });
    }
    else if(indexPage == 1){
      for (var value in backList) {
        if(value.check == -1){
          allValueChecked = false;
          break;
        }
      }
      if(allValueChecked){
        checkOptions["Back"] = true;
      }
      setState(() {

      });
    }

    else if(indexPage == 2){
    for (var value in leftList) {
    if(value.check == -1){
    allValueChecked = false;
    break;
    }
    }
    if(allValueChecked){
    checkOptions["Left"] = true;
    }
    setState(() {

    });
    }
    else if(indexPage == 3){
    for (var value in rightList) {
    if(value.check == -1){
    allValueChecked = false;
    break;
    }
    }
    if(allValueChecked){
    checkOptions["Right"] = true;
    }
    setState(() {

    });
    }
    else if(indexPage == 4){
    for (var value in trailerFrontList) {
    if(value.check == -1){
    allValueChecked = false;
    break;
    }
    }
    if(allValueChecked){
    checkOptions["Trailer Front"] = true;
    }
    setState(() {

    });
    }
    else if(indexPage == 5){
    for (var value in trailerBackList) {
    if(value.check == -1){
    allValueChecked = false;
    break;
    }
    }
    if(allValueChecked){
    checkOptions["Trailer Back"] = true;
    }
    setState(() {

    });
    }

    else if(indexPage == 6){
      for (var value in trailerLeftList) {
        print("value  fromtrailerlist${value.toJson()}");
        if(value.check == -1){
          allValueChecked = false;
          break;
        }
      }
      if(allValueChecked){
        checkOptions["Trailer Left"] = true;
      }
      setState(() {

      });
    }
    else if(indexPage == 7){
      for (var value in trailerRightList) {
        if(value.check == -1){
          allValueChecked = false;
          break;
        }
      }
      if(allValueChecked){
        checkOptions["Trailer Right"] = true;
      }
      setState(() {

      });
    }
      if(indexPage == 0 && checkOptions["Front"]==true){
        _Next();
      }
      else if(indexPage == 1 && checkOptions["Back"]==true){
        _Next();
      }
      else if(indexPage == 2 && checkOptions["Left"]==true){
        _Next();
      }
      else if(indexPage == 3 && checkOptions["Right"]==true){
        _Next();
      }
      else if(indexPage == 4 && checkOptions["Trailer Front"]==true){
        _Next();
      }
      else if(indexPage == 5 && checkOptions["Trailer Back"]==true){
        _Next();
      }
      else if(indexPage == 6 && checkOptions["Trailer Left"]==true){
        _Next();
      }
      else if(indexPage == 7 && checkOptions["Trailer Right"]==true){
        if(checkOptions.containsValue(false)){
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
                  "Some fields are missing in the following forms: \n\n"+"${checkOptions["Front"]==false?"Front\n":
                  ""}${checkOptions["Back"]==false?"Back\n":
                  ""}${checkOptions["Left"]==false?"Left\n":
                  ""}${checkOptions["Right"]==false?"Right\n":
                  ""}${checkOptions["Trailer Front"]==false?"Trailer Front\n":
                  ""}${checkOptions["Trailer Back"]==false?"Trailer Back\n":
                  ""}${checkOptions["Trailer Left"]==false?"Trailer Left\n":
                  ""}${checkOptions["Trailer Right"]==false?"Trailer Right":""}",
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
          onSave();
        }

      }
      else{

        print("else condtion");
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
  }

  void _Next() {
    setState(() {
      indexPage++;
      _scrollController.animateTo(indexPage * _ITEM_WIDTH, duration: new Duration(seconds: 2), curve: Curves.ease);
    });

  }

  void onSave() async{
    List<Map<String, dynamic>> lst0 = new List();
    List<Map<String, dynamic>> lst1 = new List();
    List<Map<String, dynamic>> lst2 = new List();
    List<Map<String, dynamic>> lst3 = new List();
    List<Map<String, dynamic>> lst4 = new List();
    List<Map<String, dynamic>> lst5 = new List();
    List<Map<String, dynamic>> lst6 = new List();
    List<Map<String, dynamic>> lst7 = new List();

    for (var value in frontList) {
      lst0.add(value.toJson());
    }
    for (var value in backList) {
      lst1.add(value.toJson());
    }
    for (var value in leftList) {
      lst2.add(value.toJson());
    }
    for (var value in rightList) {
      lst3.add(value.toJson());
    }
    for (var value in trailerFrontList ) {
    lst4.add(value.toJson());
    }
    for (var value in trailerBackList) {
    lst5.add(value.toJson());
    }
    for (var value in trailerLeftList) {
      lst6.add(value.toJson());
    }
    for (var value in  trailerRightList) {
      lst7.add(value.toJson());
    }
    SharedPreferences.getInstance().then((prefs) async {
     await prefs.setString("front", jsonEncode(lst0));
     await prefs.setString("back", jsonEncode(lst1));
     await prefs.setString("left", jsonEncode(lst2));
     await prefs.setString("right", jsonEncode(lst3));
     await prefs.setString("rightSide", jsonEncode(lst7));
     await prefs.setString("leftSide", jsonEncode(lst6));
     await prefs.setString("rearDoor", jsonEncode(lst5));
     await prefs.setString("frontNose", jsonEncode(lst4));

      Navigator.pushNamed(context, '/preview_screen');
    });

  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0076B5),
        elevation: 0.0,
      ),
      body: Column(children: <Widget>[
        Container(
          height: 50.0,
          width: width,
          color: Color(0xFF0076B5),
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mark clearly all damaged or deficiencies found by using the following symbols(S):",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          height: 50.0,
          width: width,
          color: Color(0xFF0076B5),
          padding:
          EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 10.0),
          child: ListView.builder(

            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      indexPage = index;
                    });
                  },
                  child: indexPage == index
                      ? Container(
                    width: width / 4,
                    child: Center(
                      child: Text("${options[index]}",
                          style: new TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(30.0)),
                        color: Color(0xFF70CCF5)),
                  )
                      : Container(
                    width: width / 4,
                    child: Center(
                      child: Text("${options[index]}",
                          style: new TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(30.0)),
                        color: Color(0xFFE3E3E3)),
                  ),
                ),
              );
            },
          ),
        ),
        indexPage == null ?
        Text("") : indexPage == 0 ?
        frontList.length==0? CircularProgressIndicator() : FrontScreen(frontList: frontList,) :  indexPage == 1 ?
        backList.length==0? CircularProgressIndicator() : BackScreen(backList: backList,) : indexPage == 2 ?
        leftList.length==0? CircularProgressIndicator() : LeftScreen(leftList: leftList,) : indexPage == 3 ?
        rightList.length==0? CircularProgressIndicator() : RightScreen(rightList: rightList,) : indexPage == 4 ?
        trailerFrontList.length==0? CircularProgressIndicator() : FrontNoseScreen(trailerFrontList: trailerFrontList,) : indexPage == 5 ?
        trailerBackList.length==0? CircularProgressIndicator() :RearDoorScreen (trailerBackList: trailerBackList,) : indexPage == 6 ?
        trailerLeftList.length==0? CircularProgressIndicator() : LeftSideScreen(trailerLeftList: trailerLeftList,) : RightSideScreen(trailerRightList: trailerRightList,),



      ]),
      floatingActionButton: indexPage != 7 ? FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        tooltip: 'Next',
        onPressed: checkRadioOption,
        child: Icon(Icons.arrow_right),
      ):
      FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        tooltip: 'Next',
        onPressed: checkRadioOption,
        child: Text("Save"),
      ),
    );
  }
}
