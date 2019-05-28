import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableName = 'words';

final String tableDriverRoadTest = 'DriverRoadTest';


final String columnId = '_id';
final String columnUserToken = 'userToken';
final String columnFormName = 'formName';
final String columnData = 'data';
final String columnTimestamp = 'timestamp';
final String columnVehicleName = 'vehicleName';
final String columnMechanicSignature = 'mechanicSignature';
final String columnDriverSignature = 'driverSignature';
final String columnCreatedAt = 'createdAt';


final String columnWord = 'word';

final String columnFrequency = 'frequency';

// data model class
class OfflineData {

  int id;
//  String word;
//  int frequency;
  var userToken;
  var formName;
  var vehicleName;
  var data;
  var timestamp;
  var mechanicSignature;
  var driverSignature;
  var createdAt;

  OfflineData();

  // convenience constructor to create a Word object
  OfflineData.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    userToken = map[columnUserToken];
    formName = map[columnFormName];
    vehicleName = map[columnVehicleName];
    data = map[columnData];
    mechanicSignature = map[columnMechanicSignature]!= null? map[columnMechanicSignature] : null;
    driverSignature = map[columnDriverSignature] != null? map[columnDriverSignature] : null;
    timestamp = DateTime.now();
    createdAt = DateTime.now().toUtc();
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUserToken : userToken,
      columnFormName : formName,
      columnVehicleName : vehicleName,
      columnData : data,
      columnMechanicSignature : mechanicSignature != null ? mechanicSignature : null,
      columnDriverSignature : driverSignature != null ? driverSignature : null,
      columnTimestamp : DateTime.now().toIso8601String(),
      columnCreatedAt : DateTime.now().toUtc().toIso8601String()
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "OfflineDatabase13.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableDriverRoadTest (
                $columnId INTEGER PRIMARY KEY,
                $columnMechanicSignature TEXT(100000),
                $columnDriverSignature TEXT(100000),
                $columnUserToken TEXT NOT NULL,
                $columnFormName TEXT NOT NULL,
                $columnVehicleName TEXT NOT NULL,
                $columnData TEXT NOT NULL,
                $columnTimestamp TEXT NOT NULL,
                $columnCreatedAt TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(OfflineData word) async {
    Database db = await database;
    int id = await db.insert(tableDriverRoadTest, word.toMap());
    return id;
  }

  Future<OfflineData> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableDriverRoadTest WHERE $columnId = $id');
    print("dhfvcsd" + maps.toString());
    if (maps.length > 0) {
      return OfflineData.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAllWords()
  Future<List> queryAllWord() async {
    Database db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableDriverRoadTest');
    if (maps.length > 0) {
      return maps;
    }
  }

  deleteEntry(var id) async{
    Database db = await database;
    await db.rawQuery('DELETE FROM $tableDriverRoadTest WHERE $columnId = $id');
  }

// TODO: delete(int id)
// TODO: update(Word word)
}