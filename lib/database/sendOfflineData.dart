import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:compliance/database/database_helper.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as PATH;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendOfflineData{
  var offlineData;

  DatabaseHelper helper;
  Dio dio = new Dio();

  File _imageMechanic;
  File _imageDriver;

  SharedPreferences sp;

  Map<String, String> header = new Map();
  Map<String, String> header1 = new Map();

  Future getOfflineData()async{

    sp = await SharedPreferences.getInstance();

    helper = DatabaseHelper.instance;

    header["Content-Type"] = "application/x-www-form-urlencoded";
    header["Authorization"] = sp.get("driverToken");

    header1["Content-Type"] = "multipart/form-data";
    header1["Authorization"] = sp.get("driverToken");

    offlineData = await helper.queryAllWord();

    if(offlineData != null){
      offlineData.forEach((val){
        if(val["formName"] == "Vehicle Condition Report(Pre-trip)" || val["formName"] == "Vehicle Condition Report(Post-trip)"){
          vehicleConditionReport(jsonDecode(val["data"]),val["_id"],val["timestamp"],val["createdAt"]);
        }
        else if(val["formName"] == "Driver Road Test"){
          driverRoadTrip(jsonDecode(val["data"]),val["_id"],val["timestamp"],val["createdAt"]);
        }
        else if(val["formName"] == "Inspection Report"){
          inspectionReport(jsonDecode(val["data"]), val["_id"], val["timestamp"],val["createdAt"], base64.decode(val["mechanicSignature"]), base64.decode(val["driverSignature"]));
        }
      });
    }
    else{
      print("got null");
    }
  }

  Future vehicleConditionReport(var data, var id, var timestamp, var createdAt) async{
//    data["createdAt"] = timestamp;
    data["createdAt"] = createdAt;
    await http.post(
        "http://69.160.84.135:3000/api/users/driver-road-trip",
        body: data,
        headers: header).then((v){
          print(("v is")+ v.body.toString());
          deleteFromDatabase(id).then((_){
            print("removed as well");
          });
    });
  }

  Future driverRoadTrip(var data, var id, var timestamp, var createdAt) async{
    data["createdAt"] = createdAt;

    await http.post(
        "http://69.160.84.135:3000/api/users/driver-road-test",
        body: data ,
        headers: header).then((v){
      print(v.body);
      deleteFromDatabase(id).then((_){
        print("removed as well");
      });
    });

  }

  Future inspectionReport(var data, var id, var timestamp, var createdAt, var mechanicSign, var driverSign) async{
    data["createdAt"] = createdAt;
    _createFileFromString(mechanicSign, driverSign).then((_){
      FormData formData = new FormData();
      formData.add("mechanicSignature", new UploadFileInfo(_imageMechanic, PATH.basename(_imageMechanic.path)));
      formData.add("driverSignature", new UploadFileInfo(_imageDriver, PATH.basename(_imageDriver.path)));
      formData.addAll(data);
      dio.post("http://69.160.84.135:3000/api/users/driver-inspection-report", data: formData, options: Options(
        method: 'POST',
        headers: header1,
      ))
          .then((response) {
        deleteFromDatabase(id).then((_){
          print("removed as well");
        });
      });
    });
  }

  Future deleteFromDatabase(var id) async{
    await helper.deleteEntry(id);
  }

  Future<String> _createFileFromString(var value1, var value2) async {

    if(Platform.isIOS){
      Uint8List bytes1 = value1;
      Uint8List bytes2 = value2;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file1 = File(
          "$dir/" + "mechanicSign" + ".png");
      _imageMechanic = file1;
      File file2 = File(
          "$dir/" + "driverSign" + ".png");
      _imageDriver = file2;
      await file1.writeAsBytes(bytes1);
      await file2.writeAsBytes(bytes2);
      print("file path ${file1.path}\n${file2.path}");
      return file1.path;
    }
    else{
      Uint8List bytes1 = value1;
      Uint8List bytes2 = value2;
      String dir = (await getExternalStorageDirectory()).path;
      File file1 = File(
          "$dir/" + "mechanicSign" + ".png");

      _imageMechanic = file1;

      File file2 = File(
          "$dir/" + "driverSign" + ".png");

      _imageDriver = file2;

      await file1.writeAsBytes(bytes1);
      await file2.writeAsBytes(bytes2);
      print("file path ${file1.path}\n${file2.path}");
      return file1.path;
    }


  }


}