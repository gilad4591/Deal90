import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:profanity_filter/profanity_filter.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  final filter = ProfanityFilter();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = Provider.of<Auth>(context, listen: false);
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .get();
    _enteredMessage = filter.censor(_enteredMessage);
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.userId,
      'userName': userData['name'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
