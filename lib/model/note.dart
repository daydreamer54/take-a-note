class Note {
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

  /*Verileri atama yaparken nesne türünden map yapısına çeviriyoruz */
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['title'] = _title;
    map['content'] = _content;
    map['date'] = _date;
    return map;
  }

  /*Verileri çekerken map türünden nesne türüne çeviriyoruz*/
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
