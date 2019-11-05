import 'package:flutter/material.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  var now = new DateTime.now(),
      formatter = new DateFormat('yyyy-MM-dd' + ' At ' + 'H:m');

  DatabaseHelper databaseHelper;
  List<Note> allNotes;
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String title = "";
  String content = "";

  TextEditingController _title = new TextEditingController();
  TextEditingController _content = new TextEditingController();

  @override
  void initState() {
    super.initState();
    now = new DateTime.now();

    databaseHelper = DatabaseHelper();
    allNotes = List<Note>();
    databaseHelper.listAllNotes().then((listOfMap) {
      for (Map readMap in listOfMap) {
        allNotes.add(Note.fromMap(readMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add One Note",
          style: TextStyle(fontSize: 23.0, fontFamily: 'Title'),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 25, 6, 1),
                    child: TextFormField(
                      validator: (value) {
                        if (value.length < 0) {
                          return "At least you gotta write 3 characters";
                        }
                      },
                      onSaved: (value) {
                        title = value;
                      },
                      controller: _title,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Enter One Title Please',
                        prefixIcon: Icon(Icons.title),
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 25, 6, 1),
                    child: TextFormField(
                      validator: (value) {
                        if (value.length < 5) {
                          return "At least you gotta write 5 characters";
                        }
                      },
                      onSaved: (value) {
                        content = value;
                      },
                      maxLines: 15,
                      controller: _content,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Enter Your Content Please',
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width * (0.40),
                        height: MediaQuery.of(context).size.height * (0.10),
                        child: FlatButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          onPressed: () {
                            setState(() {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                _noteAdd(
                                  Note(
                                    title,
                                    content,
                                    formatter.format(now),
                                  ),
                                );
                                _title.clear();
                                _content.clear();
                              }
                            });
                            Navigator.pop(context);
                          },
                          color: Colors.grey,
                          icon: Icon(
                            Icons.note_add,
                            color: Colors.black87,
                            size: 35.0,
                          ),
                          label: Text(
                            "Save",
                            style:
                                TextStyle(fontSize: 32.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _noteAdd(Note note) async {
    await databaseHelper.addNote(note).then((currentId) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(
          seconds: 2,
        ),
        content: Text(
          "Message Added Successfully",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ));
      setState(() {
        allNotes.insert(0, note);
      });
    });
  }
}
