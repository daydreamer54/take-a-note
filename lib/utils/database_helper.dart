import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:todo_app/model/note.dart';


 /*We'll creates our table name and columns names with that way
 so when we wanna updates any of them it will be more easy*/
class DatabaseHelper {
  String _tableName = 'note';
  String _columnID = 'id';
  String _columnTITLE = 'title';
  String _columnCONTENT = 'content';
  String _columnDATE = 'date';


  /*We will use singleton pattern to reach our methods in the app
  with that way we won't create more instance from that helper class
  so it will be more clear and understandable*/
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }


  //It checks if database created or not
  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  //It starts database
  _initializeDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String path = join(folder.path, "note.db");

    var noteDB = await openDatabase(path, version: 2, onCreate: _createDB);
    return noteDB;
  }

  //It creates database
  Future _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnTITLE TEXT, $_columnCONTENT TEXT, $_columnDATE TEXT )");
    debugPrint("DATABASE WİLL BE CREATED");
  }

  // we'll use this method to list all the notes
  Future<List<Map<String, dynamic>>> listAllNotes() async {
    var db = await _getDatabase();
    var result = db.query(_tableName, orderBy: '$_columnID DESC');
    return result;
  }

  //We'll use it when the page loaded
  Future<List<Note>> getAllMapNotes() async {
    var mapListsOfNotes = await listAllNotes();
    var allNotes = List<Note>();
    for (Map map in mapListsOfNotes) {
      allNotes.add(Note.fromMap(map));
    }
    return allNotes;
  }

  //It adds not
  Future<int> addNote(Note note) async {
    var db = await _getDatabase();
    var result = db.insert(_tableName, note.toMap());
    return result;
  }

  //It deletes note by using current note id
  Future<int> deleteOneNote(int id) async {
    var db = await _getDatabase();
    var result =
    db.delete(_tableName, where: '$_columnID = ?', whereArgs: [id]);
    return result;
  }

  //It updates note by using current id
  Future<int> updateOneNote(Note note) async {
    var db = await _getDatabase();
    var result = db.update(_tableName, note.toMap(),
        where: '$_columnID = ?', whereArgs: [note.id]);
    return result;
  }
}
