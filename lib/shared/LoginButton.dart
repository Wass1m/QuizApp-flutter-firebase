import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final Function loginMethod;
  final String text;
  final IconData icon;

  const LoginButton(
      {Key key, this.color, this.loginMethod, this.text, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: FlatButton.icon(
        label: Text(text),
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: loginMethod,
        color: color,
      ),
    );
  }
}
