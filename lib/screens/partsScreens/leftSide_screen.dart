import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:compliance/modals/PreForm.dart';

class LeftSideScreen extends StatefulWidget {
  final List<PreForm> trailerLeftList;
  LeftSideScreen({Key key, this.trailerLeftList})
      : super(
          key: key,
        );

  @override
  LeftSideScreenState createState() => LeftSideScreenState(trailerLeftList);
}

class LeftSideScreenState extends State<LeftSideScreen> {
  List<PreForm> trailerLeftList;

  LeftSideScreenState(this.trailerLeftList);

  SharedPreferences sharedPreferences;
  List<PreForm> couplingList;

  TextEditingController _messageController;


  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
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

  Future<Widget> customDialog(PreForm preform){
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

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(children: <Widget>[
      SizedBox(
        height: 3,
      ),
      Image.asset("assets/left_side.png",
          width: width / 2, height: height / 5),
      SizedBox(
        height: 2,
      ),
      Divider(
        height: 1,
      ),
      trailerLeftList == null? CircularProgressIndicator() :
      Container(
        height: height/1.97,
        child: ListView.builder(
          itemCount: trailerLeftList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Card(
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
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(trailerLeftList[index].name,
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
                                  valueSelected(val, trailerLeftList[index]);
                                },
                                activeColor: Colors.green,
                                value: 0,
                                groupValue: trailerLeftList[index].check,
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
                                  customDialog(trailerLeftList[index]);
                                  valueSelected(val, trailerLeftList[index]);
                                },
                                activeColor: Colors.red,
                                value: 1,
                                groupValue: trailerLeftList[index].check,
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
                                  valueSelected(val, trailerLeftList[index]);
                                },
                                activeColor: Colors.yellow,
                                value: 2,
                                groupValue: trailerLeftList[index].check,
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
                    trailerLeftList[index].comment == null ? Text("") :
                    trailerLeftList[index].comment == "" ? Text("") :
                    GestureDetector(
                      onTap: (){
                        _messageController = TextEditingController(text: trailerLeftList[index].comment);
                        customDialog(trailerLeftList[index]);
                      },
                      child: Text("Comment : ${trailerLeftList[index].comment}"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
