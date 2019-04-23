import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compliance/modals/DriverForm.dart';

class CouplingAndUncoupling extends StatefulWidget {
  
  CouplingAndUncoupling({Key key})
      : super(
          key: key,
        );

  @override
  CouplingAndUncouplingState createState() => CouplingAndUncouplingState();
}

class CouplingAndUncouplingState extends State<CouplingAndUncoupling> {
  List<DriverForm> finalCouplingAndUncouplingList = List();
  List<dynamic> couplingAndUncouplingMap = List();
  List<DriverForm> couplingList;
  TextEditingController _messageController;


  SharedPreferences sharedPreferences;

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

      if (sharedPreferences.get("finalCouplingAndUncouplingList") != null) {
          List<DriverForm> couplingList1;
          final jsonCoup = json.decode(sharedPreferences.get("finalCouplingAndUncouplingList"));
          if(jsonCoup!=null){
            print("jsonCoup-----> ${jsonCoup.toString()}");
          }
          
          couplingList1 =
              jsonCoup.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();  
          setState(() {
            finalCouplingAndUncouplingList = couplingList1;
          });
      }
      else{

        couplingAndUncouplingMap= jsonDecode(sharedPreferences.get("couplingAndUnCoupling")); 
        if(couplingAndUncouplingMap != null){
          List<dynamic> couplingAndUncouplingMap2 = List();
          couplingAndUncouplingMap.forEach((x){
            var name;
            x.forEach((k,l){
              if(k == "question"){
                name = l;
              }
            });
            couplingAndUncouplingMap2.add({"question": name, "answer": -1, "comment": null});
            // print("Name is $name -------- check is $check");
          });
          setState(() {
            finalCouplingAndUncouplingList = couplingAndUncouplingMap2.map<DriverForm>((i) => DriverForm.fromJson(i)).toList();
          });
      }
      }
    });
    
  }

  void _Next() async {
    List<Map<String, dynamic>> lst = new List();

    for (var value in finalCouplingAndUncouplingList) {
      lst.add(value.toJson());
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("finalCouplingAndUncouplingList", jsonEncode(lst)).then((_){
      
      Navigator.pushNamed(context, '/backing_and_parking');
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Part 3",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xFF0076B5),
        elevation: 0.0,
      ),
      body: Column(children: <Widget>[
        Container(
          height: 50.0,
          width: width,
          color: Colors.grey[300],
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "COUPLING AND UNCOUPLING",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
              ),
            ),
          ),
        ),
        Expanded(
          child: finalCouplingAndUncouplingList == null? CircularProgressIndicator() : ListView.builder(
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
                                    onChanged: (val) {
                                      valueSelected(val, finalCouplingAndUncouplingList[index]);
                                    },
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
                                    onChanged: (val) {
                                      customDialog(finalCouplingAndUncouplingList[index]);
                                      valueSelected(val, finalCouplingAndUncouplingList[index]);
                                    },
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
                                    onChanged: (val) {
                                      valueSelected(val, finalCouplingAndUncouplingList[index]);
                                    },
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
                          onTap: (){
                            _messageController = TextEditingController(text: finalCouplingAndUncouplingList[index].comment);
                            customDialog(finalCouplingAndUncouplingList[index]);
                          },
                          child: Text("Comment : ${finalCouplingAndUncouplingList[index].comment}"),
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
