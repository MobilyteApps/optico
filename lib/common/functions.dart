import 'dart:async';
import 'dart:io';

class Functions{
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

  // ignore: missing_return
  Future<bool> checkInternetConnection() async{
    try{
      final connectivity = await InternetAddress.lookup('google.com');
      if (connectivity.isNotEmpty && connectivity[0].rawAddress.isNotEmpty){
        return true;
      }
    }
    on SocketException catch (_){
      return false;
    }
  }

  Future<bool> deleteFile(var path) async{
    File file = new File('$path');
    await file.delete();
    return true;
  }
}