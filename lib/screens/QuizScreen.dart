import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizfireapp/models/QuizProvider.dart';
import 'package:quizfireapp/models/option.dart';
import 'package:quizfireapp/models/question.dart';
import 'package:quizfireapp/models/quiz.dart';
import 'package:quizfireapp/services/database.dart';
import 'package:quizfireapp/services/global.dart';
import 'package:quizfireapp/shared/Loading.dart';
import 'package:quizfireapp/shared/ProgressBar.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;

  const QuizScreen({Key key, this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: FutureBuilder(
        future: Document<Quiz>(path: 'quizzes/$quizId').getData(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          var state = Provider.of<QuizProvider>(context);
          if (!snap.hasData || snap.hasError) {
            return LoadingScreen();
          } else {
            Quiz quiz = snap.data;
            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressBar(value: state.progress),
                leading: IconButton(
                  icon: Icon(FontAwesomeIcons.times),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: state.controller,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (int idx) =>
                      state.progress = (idx / (quiz.questions.length + 1)),
                  itemBuilder: (BuildContext context, int idx) {
                    if (idx == 0) {
                      return StartPage(quiz: quiz);
                    } else if (idx == quiz.questions.length + 1) {
                      return CongratsPage(
                        quiz: quiz,
                      );
                    } else {
                      return QuestionPage(question: quiz.questions[idx - 1]);
                    }
                  }),
            );
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  final Quiz quiz;
  final PageController controller;

  const StartPage({Key key, this.quiz, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizProvider>(context);
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(quiz.title, style: Theme.of(context).textTheme.headline5),
          Divider(),
          Expanded(
            child: Text(
              quiz.description,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: state.nextPage,
                label: Text('Start Quiz!'),
                icon: Icon(Icons.poll),
                color: Colors.green,
              )
            ],
          )
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  CongratsPage({this.quiz});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congrats! You completed the ${quiz.title} quiz',
            textAlign: TextAlign.center,
          ),
          Divider(),
          Image.asset('assets/images/congrats.gif'),
          Divider(),
          FlatButton.icon(
            color: Colors.green,
            icon: Icon(FontAwesomeIcons.check),
            label: Text(' Mark Complete!'),
            onPressed: () {
              _updateUserReport(quiz);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/topics',
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }

  /// Database write to update report doc when complete
  Future<void> _updateUserReport(Quiz quiz) {
    return Global.reportRef.upsert(
      ({
        'total': FieldValue.increment(1),
        'topics': {
          '${quiz.topic}': FieldValue.arrayUnion([quiz.id])
        }
      }),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final Question question;
  QuestionPage({this.question});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizProvider>(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(question.text),
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: question.options
                .map((option) => Container(
                      height: 90,
                      child: InkWell(
                        onTap: () {
                          state.selected = option;
                          _bottomSheet(context, option, state);
                        },
                        child: Row(
                          children: [
                            Icon(
                              state.selected == option
                                  ? FontAwesomeIcons.checkCircle
                                  : FontAwesomeIcons.circle,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  option.value,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  _bottomSheet(BuildContext context, Option option, QuizProvider state) {
    bool correct = option.correct;
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(correct ? 'Good job !' : 'Wrong !'),
                  Text(
                    option.detail,
                    style: TextStyle(fontSize: 18, color: Colors.white54),
                  ),
                  FlatButton(
                    color: correct ? Colors.green : Colors.red,
                    child: Text(
                      correct ? 'Onward!' : 'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (correct) {
                        state.nextPage();
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
  }
}
