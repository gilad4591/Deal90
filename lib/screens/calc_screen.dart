import 'package:flutter/material.dart';
import 'package:finalproject/widgets/chat/messages.dart';
import 'package:finalproject/widgets/chat/new_message.dart';
import 'package:finalproject/widgets/app_drawer.dart';

class CalcScreen extends StatelessWidget {
  const CalcScreen({Key key}) : super(key: key);
  static const routeName = '/calc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('מחשבון אלכוהול'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
