import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizfireapp/services/auth.dart';
import 'package:quizfireapp/shared/LoginButton.dart';

class LoginScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(
              size: 150,
            ),
            Text(
              'Login to Start',
              style: Theme.of(context).textTheme.headline5,
            ),
            LoginButton(
                text: 'LOGIN WITH GOOGLE',
                icon: FontAwesomeIcons.google,
                color: Colors.redAccent,
                loginMethod: () async {
                  print('trying');
                  var user = await auth.signInWithGoogle();
                  user == null
                      ? print('ERROR LOGIN GOOGLE')
                      : Navigator.pushNamed(context, '/topics');
                }),
            LoginButton(
              text: 'LOGIN Anonymous',
              icon: FontAwesomeIcons.google,
              color: Colors.lightBlue,
              loginMethod: () async {
                print('trying');
                var user = await auth.signInAnonymously();
                user == null
                    ? print('ERROR LOGIN anonymously')
                    : Navigator.pushNamed(context, '/topics');
              },
            )
          ],
        ),
      ),
    );
  }
}
