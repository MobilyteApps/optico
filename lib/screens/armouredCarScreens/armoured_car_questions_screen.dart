import 'package:flutter/material.dart';
  import 'package:compliance/screens/partsScreens/back_screen.dart';
import 'package:compliance/screens/partsScreens/right_screen.dart';
import 'package:compliance/screens/partsScreens/left_screen.dart';
import 'package:compliance/screens/partsScreens/front_screen.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:compliance/modals/PreForm.dart';

class ArmouredQuestionsScreen extends StatefulWidget {
  final List<PreForm> backList;
  final List<PreForm> frontList;
  final List<PreForm> rightList;
  final List<PreForm> leftList;
  final indexPage;
  ArmouredQuestionsScreen({
    Key key,
    this.backList,
    this.frontList,
    this.rightList,
    this.leftList,
    this.indexPage
  })
      : super(
    key: key,
  );

  @override
  ArmouredQuestionsScreenState createState() => ArmouredQuestionsScreenState(backList,frontList,rightList,leftList,this.indexPage);
}

class ArmouredQuestionsScreenState extends State<ArmouredQuestionsScreen> {

  List<PreForm> backList;
  List<PreForm> frontList;
  List<PreForm> rightList;
  List<PreForm> leftList;
  ScrollController  _scrollController;
  var indexPage ;
  ArmouredQuestionsScreenState(this.backList,this.frontList,this.rightList,this.leftList,this.indexPage);

  SharedPreferences sharedPreferences;
  double itemWidth = 100.0;

  List options = [
    "Front",
    "Back",
    "Left",
    "Right"
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
  }

  void _Next() {
    setState(() {
      indexPage++;
      _scrollController.animateTo(indexPage * itemWidth, duration: new Duration(seconds: 2), curve: Curves.ease);
    });

  }

  void onSave() async{
    List<Map<String, dynamic>> lst0 = new List();
    List<Map<String, dynamic>> lst1 = new List();
    List<Map<String, dynamic>> lst6 = new List();
    List<Map<String, dynamic>> lst7 = new List();

    for (var value in frontList) {
      lst0.add(value.toJson());
    }
    for (var value in backList) {
      lst1.add(value.toJson());
    }
    for (var value in leftList) {
      lst6.add(value.toJson());
    }
    for (var value in rightList) {
      lst7.add(value.toJson());
    }
    SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString("front", jsonEncode(lst0));
      await prefs.setString("back", jsonEncode(lst1));
      await prefs.setString("right", jsonEncode(lst7));
      await prefs.setString("left", jsonEncode(lst6));
      Navigator.pushNamed(context, '/armoured_preview');
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

        indexPage == null?
        Text("") : indexPage == 0 ?
        frontList==null? CircularProgressIndicator() : FrontScreen(frontList: frontList,) :  indexPage == 1 ?
        backList==null? CircularProgressIndicator() : BackScreen(backList: backList,) : indexPage == 2 ?
        leftList==null? CircularProgressIndicator() : LeftScreen(leftList: leftList,)  : RightScreen(rightList: rightList,),

      ]),
      floatingActionButton: indexPage != 3 ? FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        onPressed: _Next,
        tooltip: 'Next',
        child: Icon(Icons.arrow_right),
      ):
      FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        onPressed: onSave,
        tooltip: 'Next',
        child: Text("Save"),
      ),
    );
  }
}
