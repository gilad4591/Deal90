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
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('ordernotification')
                .document(user.userId)
                .collection('Notifications')
                .snapshots(),
            builder: (context, notificationSnapshot) {
              if (notificationSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final notificationDocs = notificationSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: notificationDocs.length,
                itemBuilder: (context, index) => NotificationView(
                  notificationDocs[index]['orderBy'],
                  notificationDocs[index]['prodId'],
                  notificationDocs[index]['seen'],
                  notificationDocs[index].documentID,
                ),
              );
            });
      },
    );
  }
}
