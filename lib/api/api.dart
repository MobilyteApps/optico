import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class API{
  void logout(BuildContext context){
    SharedPreferences.getInstance().then((sp) {
      sp.clear().then((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    });
  }
}
