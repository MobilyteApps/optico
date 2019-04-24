import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/NewDriverForm.dart';

class BackingAndParking extends StatefulWidget {
  BackingAndParking({Key key})
      : super(
          key: key,
        );

  @override
  BackingAndParkingState createState() =>
      BackingAndParkingState();
}

class BackingAndParkingState extends State<BackingAndParking> {

  Map<dynamic, dynamic> backingAndParkingMap = Map();
  Map<dynamic, dynamic> finalBackingAndParkingMap = Map();
  Map<dynamic, dynamic> backingAndParkingMap1 = Map();
  NewDriverForm newDriverForm1;
  List<dynamic> newLst = List();
  Map<dynamic, dynamic> dummyMap = Map();
  TextEditingController _messageController;

  var jsonData;

  List<Widget> li = new List();

  SharedPreferences sharedPreferences;

  Future<Widget> customDialog(var index,var subIndex){
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => new AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Add Comment.",style: TextStyle(color: Colors.grey),),
            content: Container(
              width: 100.0,
              height: 150.0,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                        ),
                        border: InputBorder.none),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _messageController,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 50.0,right: 50.0,top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        newDriverForm1.setCommentValue(_messageController.text,index,subIndex);
                        setState(() {_messageController.text = "";});
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40.0,
                        child: Center(
                          child: Text (
                              "Save",
                              style: new TextStyle(
                                color: Colors.white,
                              )
                          ),
                        ),
                        decoration: new BoxDecoration (
                            borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                            color: Color(0xFF0076B5)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    }
    );
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;

      if(sharedPreferences.get("finalBackingAndParking") != null){
        setState(() {
        backingAndParkingMap =
            jsonDecode(sharedPreferences.get("finalBackingAndParking"));
      });
       newDriverForm1 = new NewDriverForm.fromJson(backingAndParkingMap);
      }
      else{
        setState(() {
        backingAndParkingMap =
            jsonDecode(sharedPreferences.get("backingAndParking"));
      });
      backingAndParkingMap.forEach((k,v){
        var question;
        List<dynamic> newLi = List();
        v.forEach((m){
          m.forEach((x,y){
            if(x == "question"){
              question= y;
            }
          });
          newLi.add({"question" : question,"answer" : -1, "comment" : null});
        });
        newLst.add({"titleKey" : k,"allQuestions" : newLi});
      });
      setState(() {
        backingAndParkingMap1 = finalBackingAndParkingMap;
      });
      dummyMap = {
        "data" : newLst
      };
       newDriverForm1 = new NewDriverForm.fromJson(dummyMap);
      }   
    });
  }

  Future _Next() async {

    bool allValueChecked = true;
    newDriverForm1.dataList.forEach((x1){
      x1.questionList.forEach((x2){
        if(x2.answer == -1){
          setState(() {
            allValueChecked = false;
          });
        }
      });

    });
    if(allValueChecked){
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("finalBackingAndParking", jsonEncode(newDriverForm1.toJson())).then((_){
        Navigator.pushNamed(context, '/preview_driver_road_trip');
      });
    }
    else{
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

//  void _Next() async {
//
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//    prefs.setString("finalBackingAndParking", jsonEncode(newDriverForm1.toJson())).then((_){
//      Navigator.pushNamed(context, '/preview_driver_road_trip');
//    });
//  }

  void valueSelected(int value, var index,var subIndex) {
    switch (value) {
      case 0:
      
        newDriverForm1.setCheckValue(value, index, subIndex);
        setState(() {});
        break;
      case 1:
        newDriverForm1.setCheckValue(value, index, subIndex);

        setState(() {});
        break;
      case 2:
        newDriverForm1.setCheckValue(value, index, subIndex);

        setState(() {});
        break;
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Part 4",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF0076B5),
        elevation: 0.0,
      ),
      body: Column(
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
                  "BACKING AND PARKING",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Flexible(
            child: newDriverForm1 == null? CircularProgressIndicator() :printQuestions1(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        onPressed: _Next,
        tooltip: 'Next',
        child: Text("Save"),
      ),
    );
  }

  Widget printQuestions1(){
    if(newDriverForm1 != null){
      print(newDriverForm1.dataList.length);
      li.clear();
      for(var i = 0; i<newDriverForm1.dataList.length;i++){
        li.add(
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${newDriverForm1.dataList[i].title} :",
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
                    newDriverForm1.dataList[i].questionList.length,
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
                              "${newDriverForm1.dataList[i].questionList[index].question}",
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
                                    onChanged: (val) {
                                      valueSelected(val, i,index);
                                       
                                    },
                                    activeColor: Colors.green,
                                    value: 0,
                                     groupValue: newDriverForm1.dataList[i].questionList[index].answer,
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
                                    onChanged: (val) {
                                      customDialog(i,index);
                                     valueSelected(val, i,index);
                                    },
                                    activeColor: Colors.red,
                                    value: 1,
                                    groupValue: newDriverForm1.dataList[i].questionList[index].answer,
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
                                    onChanged: (val) {
                                      valueSelected(val, i,index);
                                    },
                                    activeColor: Colors.yellow,
                                    value: 2,
                                    groupValue: newDriverForm1.dataList[i].questionList[index].answer,
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
                        newDriverForm1.dataList[i].questionList[index].comment == null ? Text("") :
                  newDriverForm1.dataList[i].questionList[index].comment == "" ? Text("") :
                  Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                  padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
                  child: GestureDetector(
                  onTap: (){
                  _messageController = TextEditingController(text: newDriverForm1.dataList[i].questionList[index].comment);
                  customDialog(i,index);
                  },
                  child: Text("Comment : ${newDriverForm1.dataList[i].questionList[index].comment}"),
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
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: li.length,
        itemBuilder: (BuildContext context, int index) {
          return li[index];
        },
      );
    }
    else{
      return Text("");
    }
  }
}
