import 'package:flutter/material.dart';

class LogOutAlertDialog extends StatelessWidget {
  const LogOutAlertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Session has expired.'),
            Text('To keep using the application you need to sign in again.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Log me out.'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        )
      ],
    );
  }
}
