import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/DriverForm.dart';

class PreTripInspection extends StatefulWidget {
  
  PreTripInspection({Key key})
      : super(
          key: key,
        );

  @override
  PreTripInspectionState createState() => PreTripInspectionState();
}

class PreTripInspectionState extends State<PreTripInspection> {
  List<DriverForm> finalPreTripInspectionList = List();
  List<dynamic> preInspectionMap = List();
  Map<dynamic,dynamic> preInspectionMap123= Map();
  List<dynamic> preInspectionMap1 = List();
  List<DriverForm> couplingList;
  Map<String,dynamic> finalpreInspectionMap = Map();
  TextEditingController _messageController;


  SharedPreferences sharedPreferences;

  // ignore: missing_return
  Future<Widget> customDialog(DriverForm preform){
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
                        preform.setCommentValue(_messageController.text);
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
                            color: Color(0xFF0076B5),
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

      if (sharedPreferences.get("finalPreTripInspectionData") != null) {
          List<DriverForm> couplingList1;
          final jsonCoup = json.decode(sharedPreferences.get("finalPreTripInspectionData"));
          if(jsonCoup!=null){
            print("jsonCoup-----> ${jsonCoup.toString()}");
          }
          
          couplingList1 =
              jsonCoup.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();  
          setState(() {
            finalPreTripInspectionList = couplingList1;
          });
      }
      else{

        preInspectionMap= jsonDecode(sharedPreferences.get("preTripInspection")); 
        if(preInspectionMap != null){
          List<dynamic> preInspectionMap2 = List();
          preInspectionMap.forEach((x){
            var name;
            x.forEach((k,l){
              if(k == "question"){
                name = l;
              }
            });
            preInspectionMap2.add({"question": name, "answer": -1, "comment": null});
            // print("Name is $name -------- check is $check");
          });
          setState(() {
            finalPreTripInspectionList = preInspectionMap2.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();
          });
      }
      }
    });
    
  }

  void _Next() async {
    List<Map<String, dynamic>> lst = new List();

    for (var value in finalPreTripInspectionList) {
      lst.add(value.toJson());
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("finalPreTripInspectionData", jsonEncode(lst)).then((_){
      
      Navigator.pushNamed(context, '/placing_the_vehicle_in_motion');
    });
  }

  void valueSelected(int value, DriverForm preForm) {
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

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFE3E3E3),
      appBar: AppBar(
        centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
        title: Align(alignment: Alignment.centerRight,child: Text("Part 1",style: TextStyle(color: Colors.white),),),
        backgroundColor: Color(0xFF0076B5),
        elevation: 0.0,
      ),
      body: Column(children: <Widget>[
        Container(
          height: 50.0,
          width: width,
          color: Color(0xFFE3E3E3),
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PRE-TRIP INSPECTION",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ),
          ),
        ),
        Expanded(
          child: finalPreTripInspectionList == null? CircularProgressIndicator() : ListView.builder(
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
                                    onChanged: (val) {
                                      valueSelected(val, finalPreTripInspectionList[index]);
                                    },
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
                                    onChanged: (val) {
                                      customDialog(finalPreTripInspectionList[index]);
                                      valueSelected(val, finalPreTripInspectionList[index]);
                                    },
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
                                    onChanged: (val) {
                                      valueSelected(val, finalPreTripInspectionList[index]);
                                    },
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
                          onTap: (){
                            _messageController = TextEditingController(text: finalPreTripInspectionList[index].comment);
                            customDialog(finalPreTripInspectionList[index]);
                          },
                          child: Text("Comment : ${finalPreTripInspectionList[index].comment}"),
                        ),
                      ),
                    ],
                  ),
                
              );
            },
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 50.0),
        // ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0076B5),
        onPressed: _Next,
        tooltip: 'Next',
        child: Icon(Icons.arrow_right),
      ),
    );
  }
}
