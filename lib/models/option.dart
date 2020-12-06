class Option {
  String value;
  String detail;
  bool correct;

  Option({this.value, this.detail, this.correct});

  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}
