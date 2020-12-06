import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizfireapp/screens/LoginScreen.dart';
import 'package:quizfireapp/screens/TopicsScreen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null ? LoginScreen() : TopicsScreen();
  }
}
