import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:finalproject/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:provider/provider.dart';

class DealRecommendationsArgs{
  final String dealId;

  DealRecommendationsArgs(this.dealId);
}

class DealRecommendationsScreen extends StatefulWidget {
  static const routeName = '/deal_recommendations';

  @override
  _DealRecommendationsScreenState createState() => _DealRecommendationsScreenState();
}

class _DealRecommendationsScreenState extends State<DealRecommendationsScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final DealRecommendationsArgs dealArgs = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text("Deal's recommendations"),
      ),
      body: Column(
        children: [
          Expanded(child: Recommendations(dealId: dealArgs.dealId)),
          NewRecommendMessage(dealId: dealArgs.dealId),
        ],
      ),
    );
  }
}

class Recommendations extends StatelessWidget {
  final String dealId;
  const Recommendations({Key key, this.dealId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false);

    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('recommendations')
                .doc(dealId)
                .collection('comments')
                .orderBy(
              'createdAt',
              descending: true,
            )
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (context, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['userId'] == user.userId,
                  chatDocs[index]['userId'],
                  key: ValueKey(chatDocs[index].documentID),
                ),
              );
            });
      },
    );
  }
}


class NewRecommendMessage extends StatefulWidget {
  final String dealId;
  NewRecommendMessage({Key key, @required this.dealId}) : super(key: key);

  @override
  _NewRecommendMessageState createState() => _NewRecommendMessageState();
}

class _NewRecommendMessageState extends State<NewRecommendMessage> {
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


    FirebaseFirestore.instance.collection('recommendations')
        .doc(widget.dealId)
        .collection('comments').add({
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
              decoration: InputDecoration(labelText: 'Send Your Recommend'),
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