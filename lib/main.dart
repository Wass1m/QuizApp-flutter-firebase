import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizfireapp/WelcomeScreen.dart';
import 'package:quizfireapp/models/report.dart';
import 'package:quizfireapp/screens/AboutScreen.dart';
import 'package:quizfireapp/screens/LoginScreen.dart';
import 'package:quizfireapp/screens/ProfileScreen.dart';
import 'package:quizfireapp/screens/TopicsScreen.dart';
import 'package:quizfireapp/screens/Wrapper.dart';
import 'package:quizfireapp/services/auth.dart';
import 'package:quizfireapp/services/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<Report>.value(value: Global.reportRef.documentStream),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Nunito',
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.black87,
          ),
          brightness: Brightness.dark,
          textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 18),
            bodyText2: TextStyle(fontSize: 16),
            button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            headline5: TextStyle(fontWeight: FontWeight.bold),
            subtitle1: TextStyle(color: Colors.grey),
          ),
          buttonTheme: ButtonThemeData(),
        ),
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => LoginScreen(),
          '/topics': (context) => TopicsScreen(),
          '/profile': (context) => ProfileScreen(),
          '/about': (context) => AboutScreen()
        },
      ),
    );
  }
}
