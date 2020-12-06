import 'package:quizfireapp/models/option.dart';

class Question {
  String text;
  List<Option> options;
  Question({this.text, this.options});

  Question.fromMap(Map data) {
    text = data['text'] ?? '';
    options =
        (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
  }
}
