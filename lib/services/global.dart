import 'package:quizfireapp/models/quiz.dart';
import 'package:quizfireapp/models/report.dart';
import 'package:quizfireapp/models/topic.dart';
import 'package:quizfireapp/services/database.dart';

class Global {
  static final Map models = {
    Topic: (data) => Topic.fromMap(data),
    Quiz: (data) => Quiz.fromMap(data),
    Report: (data) => Report.fromMap(data),
  };

  // Firestore References for Writes
  static final Collection<Topic> topicsRef = Collection<Topic>(path: 'topics');
  static final UserData<Report> reportRef =
      UserData<Report>(collection: 'reports');
}
