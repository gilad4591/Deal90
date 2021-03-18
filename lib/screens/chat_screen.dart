import 'package:flutter/material.dart';
import 'package:finalproject/widgets/chat/messages.dart';
import 'package:finalproject/widgets/chat/new_message.dart';
import 'package:finalproject/widgets/app_drawer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key key}) : super(key: key);
  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal90 Chat'),
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
