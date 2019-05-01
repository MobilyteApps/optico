import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:simple_permissions/simple_permissions.dart';


import 'dart:ui';

class FinalPreInspectionReport extends StatefulWidget {
  @override
  FinalPreInspectionReportState createState() => new FinalPreInspectionReportState();
}

class FinalPreInspectionReportState extends State<FinalPreInspectionReport> {
  Map<String, String> header = new Map();

  List<dynamic> allData = List();

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp){
      header["Authorization"] = sp.get("driverToken");
    }).then((_){
      http.get("http://69.160.84.135:3000/api/users/history?formName=Pre-Inspection%20Form",headers: header).then((data){
        Map result = jsonDecode(data.body);
        result.forEach((k,v){
          if(k == "data"){
            setState(() {
              allData = v;
            });

          }
        });
        print("${result.toString()}");
      }).catchError((err){
        print("${err.toString()}");
      });
    });
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
//    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);

    Future<PermissionStatus> status= PermissionHandler().checkPermissionStatus(permission);

    status.then((data){
      if(data.toString() == "PermissionStatus.denied"){
        showDialog(
          barrierDismissible: false,
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
                "Please go to setting and change\nthe permission because it\nis required for the Application\nto proceed.",
                style: TextStyle(fontSize: 15),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        PermissionHandler().openAppSettings().then((bool hasOpened) =>
                            Navigator.pop(context));
                      },
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
    });
  }

  Future<File> createFileOfPdfUrl(var url) async {


    if(Platform.isIOS){
      var filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getExternalStorageDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file;
    }
    else{
      PermissionGroup permission = PermissionGroup.storage;
      await requestPermission(permission);
      var filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getExternalStorageDirectory()).path;
      File file = new File('$dir/$filename');
      await file.writeAsBytes(bytes);
      return file;
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(fit: StackFit.expand, children: <Widget>[

      new Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leading: GestureDetector(
            onTap: ()  {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/vehicle', (Route<dynamic> route) => false);
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("Vehicle Condition Report(Pre-Trip)",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color(0xFF0076B5),
        ),
//        drawer: CommonDrawer(),
        body: Padding(padding: EdgeInsets.only(top: 10.0,),
          child: allData.length == null? CircularProgressIndicator():ListView.builder(
            itemCount: allData.length,
            itemBuilder: (BuildContext context, int index){
              DateTime date1 = DateTime.parse(allData[index]["date"]);
              DateTime date = date1.toLocal();
              var url = allData[index]["pdf"];
              return Padding(padding: EdgeInsets.only(top: 2.0,bottom: 2.0),child: InkWell(
                onTap: (){
                  print("truck");
                  createFileOfPdfUrl(url).then((pdfFile){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen(pdfFile.path)));
                  });

                },
                child: Container(
                  color: Colors.white,
                  height: 60.0,
                  width: width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text("${allData[index]["vehicleName"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              date.hour.toInt() > 12 ? Text("${(date.hour.toInt())-12}:${date.minute}PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),) :
                              date.hour.toInt() == 0 ? Text("${(date.hour.toInt())+12}:${date.minute}AM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)  :
                              Text("${date.hour}:${date.minute}AM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              Text("${date.month.toString()}/${date.day.toString()}/${date.year.toString()}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("${allData[index]["countOfDefect"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              Text("Faults",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),);
            },
          ),
        ),
      )
    ]);
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Preview"),
        ),
        path: pathPDF);
  }
}
