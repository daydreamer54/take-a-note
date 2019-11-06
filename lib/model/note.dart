class Note {
  //We've created them private not to reach and control from anywhere
  int _id;
  String _title;
  String _content;
  String _date;

  String get date => _date;

  set date(String newDate) {
    this._date = newDate;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  Note(this._title, this._content, this._date);

  Note.withID(this._id, this._title, this._content, this._date);

  /*When we try to send our variables it converts them to map constructor
  because sqflite likes working with map*/
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['title'] = _title;
    map['content'] = _content;
    map['date'] = _date;
    return map;
  }

  /*When we try to send our variables it converts them to class constructor
  because they are in map constructor before we convert them*/
  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._content = map['content'];
    this._date = map['date'];
  }

  @override
  String toString() {
    return 'Note{_id: $_id, _title: $_title, _content: $_content, _date: $_date}';
  }
}
