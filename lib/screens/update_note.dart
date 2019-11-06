import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'package:todo_app/main.dart';

class UpdateTheNote extends StatefulWidget {
  final Note note;
  UpdateTheNote({Key key, @required this.note}) : super(key: key);
  @override
  _UpdateTheNote createState() => _UpdateTheNote();
}

class _UpdateTheNote extends State<UpdateTheNote> {

  //Here we get an instance from helper class to reach our methods
  DatabaseHelper databaseHelper;

  //It creates a list of our notes
  List<Note> allNotes;

  //It controls our form to reach our save and other validates controls
  var formKey = GlobalKey<FormState>();
  var now = new DateTime.now(),
      formatter = new DateFormat('yyyy-MM-dd' + ' At ' + 'H:m');

  int id = 0;
  String title = "";
  String content = "";

  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    /*When page loaded we get the variables from main page*/
    _title.text = widget.note.title;
    _content.text = widget.note.content;
    id = widget.note.id;
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update The Note",
          style: TextStyle(
            fontSize: 23.0,
            fontFamily: 'Title',
          ),
        ),
      ),
      body: Container(
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
                        if (value.length <=0) {
                          return "At least you gotta write 3 characters";
                        } else {
                          return null;
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
                        if (value.length <=0) {
                          return "At least you gotta write 10 characters";
                        } else {
                          return null;
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
                                _noteUpdate(
                                  Note.withID(
                                    id,
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
                            "Update",
                            style:
                                TextStyle(fontSize: 28.0, color: Colors.black),
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

  /*void _noteUpdate(Note note) async {
    await databaseHelper.updateOneNote(note).then((updatedID) {
      setState(() {
        allNotes[updatedID] = note;
      });
    });
  }*/

  void _noteUpdate(Note note) async {
    await databaseHelper.updateOneNote(note).then((updatedID) {
      if (allNotes.length > updatedID)
        setState(() {
          allNotes[updatedID] = note;
        });
      else
        print("liste: ${allNotes.toString()} gelen cevap: updatedID");
    });
  }
}
