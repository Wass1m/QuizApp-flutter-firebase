import 'package:quizfireapp/models/question.dart';

class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {this.title,
      this.questions,
      this.video,
      this.description,
      this.id,
      this.topic});

  factory Quiz.fromMap(Map data) {
    return Quiz(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      video: data['video'] ?? '',
      topic: data['topic'] ?? '',
      questions: (data['questions'] as List ?? [])
          .map((element) => Question.fromMap(element))
          .toList(),
    );
  }
}
