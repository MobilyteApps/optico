import 'package:flutter/material.dart';
import 'package:compliance/modals/DriverForm.dart';

import 'package:compliance/screens/inspection_report.dart';

class ListSelection extends StatefulWidget {
  final List<DriverForm> allDataBodyPart;
  final List<DriverForm> allDataTrailer;
  final value1;
  ListSelection({
    Key key,
    this.allDataBodyPart,
    this.allDataTrailer,
    this.value1
  })
      : super(
    key: key,
  );

  @override
  ListSelectionState createState() => new ListSelectionState(allDataBodyPart,allDataTrailer,value1);
}

class ListSelectionState extends State<ListSelection> {
  List<DriverForm> allDataBodyPart;
  List<DriverForm> allDataTrailer;
  var value1;
  ListSelectionState(this.allDataBodyPart,this.allDataTrailer,this.value1);

  @override
  void initState() {
    super.initState();
  }

  void valueSelected(var value, DriverForm preForm) {
    preForm.setCheckValue(value);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(

        title: Text("Select defective items",

            textAlign: TextAlign.end, style:
            TextStyle(color: Colors.white)),

        centerTitle: true,

        backgroundColor: Color(0xFF0076B5),

      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: width,
            height: height/1.25,
            child: value1 == 1 ? ListView.builder(
                itemCount: allDataBodyPart.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    width: width,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: allDataBodyPart[index].answer,
                          onChanged: (value) {
                            valueSelected(value, allDataBodyPart[index]);
                          },
                        ),
                        Expanded(
                          child: Text(allDataBodyPart[index].question),
                        ),
                      ],
                    ),
                  );
                }
            ) :
            ListView.builder(
                itemCount: allDataTrailer.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    width: width,
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Checkbox(
//                          checkColor: Color(0xFF0076B5),
                          activeColor: Color(0xFF0076B5),
                          value: allDataTrailer[index].answer,
                          onChanged: (value) {
                            valueSelected(value, allDataTrailer[index]);
                          },
                        ),
                        Expanded(
                          child: Text(allDataTrailer[index].question),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context,InspectionReport(
                allDataTrailer: allDataTrailer,
                allDataBodyPart: allDataBodyPart,
                value1: value1,
              ));
            },
            child: Container(
              height: 30.0,
              width: 80.0,
              color: Color(0xFF0076B5),
              child: Align(
                child: Text("Save",style: TextStyle(color: Colors.white),),
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
