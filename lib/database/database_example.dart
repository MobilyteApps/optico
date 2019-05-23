import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:compliance/database/database_helper.dart';

class DatabaseClass extends StatefulWidget {
  @override
  _DatabaseClassState createState() => _DatabaseClassState();
}

class _DatabaseClassState extends State<DatabaseClass>{

  Database database;

  @override
  void initState(){
    super.initState();
//    getDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                getDatabase();
              },
              child: Text("getDatabase"),
            ),
            RaisedButton(
              onPressed: () async {

                OfflineData offlineData = OfflineData();
//                word.word = 'hello';
//                word.frequency = 15;
                offlineData.vehicleName = "truck";
                offlineData.data = "hello";
                offlineData.formName = "Driver Road Test Form";
                offlineData.userToken = "userToken";
                DatabaseHelper helper = DatabaseHelper.instance;
                int id = await helper.insert(offlineData);
                print('inserted row: $id');

//                insertValuesToDatabase();
              },
              child: Text("insertValues"),
            ),
            RaisedButton(
              onPressed: () async {

                DatabaseHelper helper = DatabaseHelper.instance;
//                int rowId = 2;
//                OfflineData word1 = (await helper.queryAllWord()) as OfflineData;
                var data = await helper.queryAllWord();
                print("data is" + data.toString());
//                OfflineData word = await helper.queryWord(rowId);
//                if (word == null) {
//                  print('read row $rowId: empty');
//                } else {
//                  DateTime x = word.timestamp;
//                  print('timestamp : ${x.toIso8601String()} \n ${word.vehicleName} \n ${word.formName}');
//                }

//                readValuesFromDatabase();
              },
              child: Text("readValues"),
            ),
            RaisedButton(
              onPressed: (){
                deleteDatabaseFunction();
              },
              child: Text("delete database"),
            ),
//            RaisedButton(
//              onPressed: (){
//                DatabaseHelper helper = DatabaseHelper.instance;
//                helper.dropTable();
//              },
//              child: Text("delete TABLE"),
//            ),
          ],
        ),
      ),
    );
  }

  Future getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    print("path is "+path);

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        });

  }

  insertValuesToDatabase() async {
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });
  }

  readValuesFromDatabase() async{
    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    print("list is" + list.toString());
  }

  deleteDatabaseFunction() async{

    await deleteDatabase(database.path).then((_){
      print("database deleted");
    });
  }

}