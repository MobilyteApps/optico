import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API{
  void logout(BuildContext context){
    SharedPreferences.getInstance().then((sp) {
      sp.clear().then((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    });
  }

  Future<bool> login(var loginDetails) async {

       await http.post("http://69.160.84.135:3000/api/users/login", body: loginDetails).then((data){
        Map<String, dynamic> mp = json.decode(data.body);
        if (mp.containsKey("data")) {
          mp.forEach((k, v) {
            if (k == "data") {
              SharedPreferences.getInstance().then((sp) {

                sp.setString("fullName", v["fullName"]);

                sp.setString("address", v["address"]);

                sp.setString("companyName", v["company"]);

                sp.setString(
                    "emailAddress", v["emailAddress"]);

                sp.setInt("phoneNumber", v["phoneNumber"]);

                sp.setString("license", v["driverLicenceNo"]);
              });
            } else if (k == "token") {
              SharedPreferences.getInstance().then((sp) {
                sp = sp;

                sp.setString("driverToken", v);
              });
            }
          });
          return true;
        }
        else{
          return false;
        }

      });
       return false;

  }
}
