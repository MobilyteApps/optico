import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/NewDriverForm.dart';

class PlacingTheVehicleInMotion extends StatefulWidget {
  PlacingTheVehicleInMotion({Key key})
      : super(
          key: key,
        );

  @override
  PlacingTheVehicleInMotionState createState() =>
      PlacingTheVehicleInMotionState();
}

class PlacingTheVehicleInMotionState extends State<PlacingTheVehicleInMotion> {
  Map<dynamic, dynamic> placingTheVehicleInMotionMap = Map();
  Map<dynamic, dynamic> finalPlacingTheVehicleInMotionMap = Map();
  Map<dynamic, dynamic> placingTheVehicleInMotionMap1 = Map();
  NewDriverForm newDriverForm;
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
                        newDriverForm.setCommentValue(_messageController.text,index,subIndex);
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

      if(sharedPreferences.get("finalPlacingTheVehicleInMotion") != null){
        setState(() {
        placingTheVehicleInMotionMap =
            jsonDecode(sharedPreferences.get("finalPlacingTheVehicleInMotion"));
      });
       newDriverForm = new NewDriverForm.fromJson(placingTheVehicleInMotionMap);
      }
      else{
        setState(() {
        placingTheVehicleInMotionMap =
            jsonDecode(sharedPreferences.get("placingTheVehicleInMotion"));
      });
      placingTheVehicleInMotionMap.forEach((k,v){
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
        placingTheVehicleInMotionMap1 = finalPlacingTheVehicleInMotionMap;
      });
      dummyMap = {
        "data" : newLst
      };
       newDriverForm = new NewDriverForm.fromJson(dummyMap);
      }   
    });
  }

  void _Next() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("finalPlacingTheVehicleInMotion", jsonEncode(newDriverForm.toJson())).then((_){
      Navigator.pushNamed(context, '/coupling_and_uncoupling');
    });
  }

  void valueSelected(int value, var index,var subIndex) {
    switch (value) {
      case 0:
      
        newDriverForm.setCheckValue(value, index, subIndex);
        setState(() {});
        break;
      case 1:
        newDriverForm.setCheckValue(value, index, subIndex);

        setState(() {});
        break;
      case 2:
        newDriverForm.setCheckValue(value, index, subIndex);

        setState(() {});
        break;
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFE3E3E3),
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Part 2",
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
            color: Color(0xFFE3E3E3),
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
          SizedBox(
            height: 10,
          ),

          Flexible(
            child: newDriverForm == null? CircularProgressIndicator() :printQuestions1(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        onPressed: _Next,
        tooltip: 'Next',
        child: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget printQuestions1(){
    if(newDriverForm != null){
      print(newDriverForm.dataList.length);
      li.clear();
      for(var i = 0; i<newDriverForm.dataList.length;i++){
        li.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 10.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${newDriverForm.dataList[i].title} :",
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
                    newDriverForm.dataList[i].questionList.length,
                itemBuilder: (BuildContext context, int index) {
                  // print("${backingAndParkingMap.values.elementAt(i)[index]}");
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
                              "${newDriverForm.dataList[i].questionList[index].question}",
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
                                     groupValue: newDriverForm.dataList[i].questionList[index].answer,
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
                                    groupValue: newDriverForm.dataList[i].questionList[index].answer,
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
                                    groupValue: newDriverForm.dataList[i].questionList[index].answer,
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
                        newDriverForm.dataList[i].questionList[index].comment == null ? Text("") :
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0,bottom: 5.0),
                            child: GestureDetector(
                              onTap: (){
                                _messageController = TextEditingController(text: newDriverForm.dataList[i].questionList[index].comment);
                                customDialog(i,index);
                              },
                              child: Text("Comment : ${newDriverForm.dataList[i].questionList[index].comment}"),
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
