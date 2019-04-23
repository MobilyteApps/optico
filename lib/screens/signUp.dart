import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
_launchURL() async {
  const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isChecked = false;

  final _companyNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _fleetSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String url = 'http://10.10.30.73:3000/api/users/register';

  SharedPreferences sharedPreferences;


  String _validateEmail(String value) {
    if (value.isEmpty) {
return null;
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);
    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {

      return null;

    }
    if (value.length >= 8) {
      return null;
    }
    return 'Password must be upto 8 characters';
  }

  Future<Widget> showAlert(){
    return showDialog(
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
            "All fields are Mandatory.",
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

  void onSignUp(){
    if(_companyNameController.text == null || _emailController.text == null || _fleetSizeController.text == null || _fullNameController.text == null || _passwordController.text == null || _phoneNumberController.text == null){
      showAlert();
    }
    else{
      return null;
    }
  }


  Future<dynamic> signUpApi(
    var companyName,
    var fullName,
    var email,
    var password,
    var phoneNumber,
    var fleetSize,

  ) async {
    if(isChecked){
      if (companyName.length == 0 ||
          fullName.length == 0 ||
          email.length == 0 ||
          password.length == 0 ||
          phoneNumber.length == 0 ||
          fleetSize.length == 0) {
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
      } else {
        var data = {
          "emailAddress": email,
          "password": password,
          "company": companyName,
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "fleetSize": fleetSize,
        };
        http.post('$url',
          body: data
        ).then((value){
          print("value is------------>>>>>>> ${jsonDecode(value.body)}");
          var result = jsonDecode(value.body);
          result.forEach((k,v){
            if(k == "message"){
              if(v == "Success."){
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
                        "Account Created! Go To Login.",
                        style: TextStyle(fontSize: 15),
                      ),
                      actions: <Widget>[
                        Row(
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamedAndRemoveUntil('/signIn', (Route<dynamic> route) => false),
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
                        v.toString(),
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
          });
        });
      }
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
              "You must accept our Terms & Conditions\nbefore Sign Up.",
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

  @override
  Widget build(BuildContext context) {
    GestureDetector(onTap: () => SystemChrome.setEnabledSystemUIOverlays([]));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(25, 10, 15, 25),
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 210, 0),
              child: Image.asset("assets/car_logo.png",
                  height: 90, width: 200, scale: 3.0),
            ),
            Card(
              elevation: 8.0,
              margin: EdgeInsets.fromLTRB(8, 35, 8, 20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Sign up to get started",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0076B5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(children: <Widget>[

                        TextFormField(
                          cursorColor: Colors.blue,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0),
                            filled: true,
                            border: UnderlineInputBorder(),
                            labelText: 'Company Name',
                          ),
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          controller: _companyNameController,
                          //validator: _validateCompanyName,
                        ),

                      SizedBox(
                        height: 10,
                      ),

                          TextFormField(
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0),
                              filled: true,
                              border: UnderlineInputBorder(),
                              labelText: 'Full Name',
                            ),
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            controller: _fullNameController,
                          ),

                        SizedBox(
                          height: 10,
                        ),

                          TextFormField(
                            cursorColor: Colors.blue,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0),
                              filled: true,
                              border: UnderlineInputBorder(),
                              labelText: 'Your Company email address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            validator: _validateEmail,
                            autovalidate: true,
                            controller: _emailController,
                          ),

                        SizedBox(
                          height: 10,
                        ),

                            TextFormField(
                              obscureText: true,
                              cursorColor: Colors.blue,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0),
                                filled: true,
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                              ),
                              keyboardType: TextInputType.emailAddress,
                             autovalidate: true,
                              validator: _validatePassword,

                              controller: _passwordController,
                            ),

                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //filled: true,
                            border: UnderlineInputBorder(),
                            labelText: 'Phone No.',
                          ),
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                            TextFormField(
                              obscureText: true,
                              cursorColor: Colors.blue,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                                filled: true,
                                border: UnderlineInputBorder(),
                                labelText: 'Fleet Size',
                              ),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              controller: _fleetSizeController,
                            ),

                         SizedBox(
                          height: 10,
                        ),
                        Row(
                            children:<Widget> [
                              Checkbox(
                                value: isChecked,
                                activeColor: Color(0xFF70CCF5),
                                onChanged: (value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("By Signing up, you accept our,",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15)),
                                  InkWell(
                                    onTap: _launchURL,
                                    child:Text("Terms & Conditions",style: TextStyle(color: Color(0xFF0076B5),fontWeight: FontWeight.bold,fontSize: 15,decoration: TextDecoration.underline)),
                                  ),
                                ],
                              ),

                            ]),
                        SizedBox(height: 25),
                        Container(
                            child: Column(
                          children: <Widget>[
                            RaisedButton(
                              textColor: Colors.white,
                              color: Color(0xFF0076B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              padding:
                                  EdgeInsets.fromLTRB(80.0, 10.0, 80.0, 10.0),
                              onPressed: (){
                                signUpApi(_companyNameController.text, _fullNameController.text, _emailController.text, _passwordController.text, _phoneNumberController.text, _fleetSizeController.text);
                              },
                              child: Text('SIGN UP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                            ),
                            SizedBox(height: height / 10),
                          ],
                        )),

                      
                    ]),
                )
                    )]),
            ),
            SizedBox(
              height: height / 35,
            ),
            Column(
              children: <Widget>[
                InkWell(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 35),
                      Text(
                        "Already have an account? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      Text("Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFF0076B5),
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/signIn', (Route<dynamic> route) => false);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
