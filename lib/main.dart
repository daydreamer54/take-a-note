import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_note.dart';
import 'package:todo_app/screens/update_note.dart';
import './utils/database_helper.dart';
import './model/note.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MainPage(),
    ),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DatabaseHelper databaseHelper;

  List<Note> allNotes;

  int id = 0;
  int currentID = 0;
  String title = "";
  String content = "";

  @override
  void initState() {
    super.initState();
    allNotes = List<Note>();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.white,
        tooltip: 'Add Note',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 45.0,
          color: Colors.black,
        ),
        backgroundColor: Colors.orange,
      ),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<Notes>(
            color: Colors.blueGrey,
            padding: EdgeInsets.all(
              7.0,
            ),
            tooltip: 'Menu',
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2.0,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            onSelected: (note) {
              if (note.index == 0) {
                _deleteAllNotes();
              } else {
                debugPrint(note.index.toString());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  "Delete All Notes",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: Notes.delete,
                height: 40.0,
              ),
              PopupMenuItem(
                child: Text(
                  "Archive All Notes",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: Notes.archive,
                height: 40.0,
              ),
            ],
          ),
        ],
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          "My Notes",
          style: TextStyle(
            fontFamily: 'Title',
            fontSize: 23.0,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: databaseHelper.getAllMapNotes(),
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            allNotes = snapshot.data;
            return Container(
              child: ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      //We get the values which not has clicked
                      setState(() {
                        id = allNotes[index].id;
                        title = allNotes[index].title;
                        content = allNotes[index].content;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateTheNote(
                              note: allNotes[index],
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * (0.30),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            allNotes[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Title',
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Expanded(
                            child: Text(
                              allNotes[index].content,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Content',
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.delete_forever,
                                  size: 35.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    databaseHelper
                                        .deleteOneNote(allNotes[index].id)
                                        .then((removeID) {
                                      setState(() {
                                        allNotes.removeAt(index);
                                      });
                                    });
                                  });
                                },
                                alignment: Alignment.center,
                              ),
                              SizedBox(
                                width: 80.0,
                              ),
                              Expanded(
                                child: Text(
                                  allNotes[index].date,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "You don't have any notes yet",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  //This method clear all the notes immediately
  void _deleteAllNotes() async {
    await databaseHelper.deleteAllNotes().then((removedNote) {
      debugPrint(removedNote.toString() + " note deleted");
    });
    //After deleting we clear the screen with set state
    setState(() {
      allNotes.clear();
    });
  }
}

enum Notes { delete, archive }
