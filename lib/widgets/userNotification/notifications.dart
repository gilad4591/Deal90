import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalproject/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/widgets/userNotification/notificationview.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key key}) : super(key: key);

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
                .collection('ordernotification')
                .doc(user.userId)
                .collection('Notifications')
                .snapshots(),
            builder: (context, notificationSnapshot) {
              if (notificationSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final notificationDocs = notificationSnapshot.data.docs;
              return notificationDocs.length == 0
                  ? NoOrdersYet()
                  : ListView.builder(
                      reverse: true,
                      itemCount: notificationDocs.length,
                      itemBuilder: (context, index) => NotificationView(
                        notificationDocs[index]['orderBy'],
                        notificationDocs[index]['prodId'],
                        notificationDocs[index]['seen'],
                        notificationDocs[index].docID,
                      ),
                    );
            });
      },
    );
  }
}

class NoOrdersYet extends StatelessWidget {
  const NoOrdersYet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nothing ordered from you yet ',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Text(
            '😔',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
