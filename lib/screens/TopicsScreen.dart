import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizfireapp/models/topic.dart';
import 'package:quizfireapp/screens/QuizScreen.dart';
import 'package:quizfireapp/services/global.dart';
import 'package:quizfireapp/shared/BottomNav.dart';
import 'package:quizfireapp/shared/Loading.dart';
import 'package:quizfireapp/shared/ProgressBar.dart';

class TopicsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Global.topicsRef.getData(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            List<Topic> topics = snap.data;
            return Scaffold(
              drawer: TopicsList(
                topics: topics,
              ),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: Text('Topics'),
                actions: [
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.userCircle,
                      color: Colors.pink[200],
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                  )
                ],
              ),
              body: GridView.count(
                padding: EdgeInsets.all(10),
                primary: false,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                children:
                    topics.map((topic) => TopicItem(topic: topic)).toList(),
              ),
              bottomNavigationBar: AppBottomNav(),
            );
          } else {
            print(snap.error);
            return LoadingScreen();
          }
        });
  }
}

class TopicItem extends StatelessWidget {
  final Topic topic;

  const TopicItem({Key key, this.topic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: topic.img,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TopicScreenDetail(
                      topic: topic,
                    )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/covers/${topic.img}',
                fit: BoxFit.contain,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        topic.title,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style:
                            TextStyle(height: 1.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              TopicProgress(
                topic: topic,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopicScreenDetail extends StatelessWidget {
  final Topic topic;

  const TopicScreenDetail({Key key, this.topic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Hero(
            tag: topic.img,
            child: Image.asset(
              'assets/images/covers/${topic.img}',
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Text(
            topic.title,
            style:
                TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          QuizList(
            topic: topic,
          )
        ],
      ),
    );
  }
}

class QuizList extends StatelessWidget {
  final Topic topic;

  const QuizList({Key key, this.topic}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: topic.quizzes
          .map((quiz) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                elevation: 4,
                margin: EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizScreen(quizId: quiz.id)));
                  },
                  child: Container(
                    child: ListTile(
                      title: Text(quiz.title),
                      subtitle: Text(quiz.description),
                      leading: QuizBadge(
                        topic: topic,
                        quizId: quiz.id,
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class TopicsList extends StatelessWidget {
  final List<Topic> topics;

  const TopicsList({Key key, this.topics}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int idx) => Divider(),
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int idx) {
          Topic topic = topics[idx];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  topic.title,
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              QuizList(
                topic: topic,
              )
            ],
          );
        },
      ),
    );
  }
}
