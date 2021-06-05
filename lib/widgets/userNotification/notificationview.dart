import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationView extends StatelessWidget {
  const NotificationView(this.orderBy, this.prodId, this.seen, this.documentId,
      {this.key})
      : super(key: key);
  final Key key;
  final String orderBy;
  final String documentId;
  final String prodId;
  final String seen;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: seen.contains('false') ? Colors.blue[600] : Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(orderBy)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Deal code:\n' +
                              prodId +
                              '\nOrdered by:\n' +
                              'Name: ' +
                              snapshot.data['name'] +
                              '\nPhone: ' +
                              snapshot.data['phone'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        if (seen.contains('false'))
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            // height: MediaQuery.of(context).size.height * 0.1,
                            child: Column(
                              children: [
                                Text(
                                  'New order!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                ButtonTheme(
                                  minWidth: 20.0,
                                  height: 20.0,
                                  buttonColor: Colors.white,
                                  child: RaisedButton(
                                    onPressed: () {
                                      changeToSeenNotification(
                                          user, documentId);
                                    },
                                    child: Icon(Icons.check),
                                  ),
                                ),
                                Text(
                                  "Mark as read",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // WidgetNoName(prodId, user),
        Container(
          decoration: BoxDecoration(
            // color: Colors.blue.opacity(0.0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.3,
          // height: MediaQuery.of(context).size.height * 0.5,
          margin: EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child('/products/$prodId')
                    .once()
                    .then((value) => value.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                    snapshot.data['imageUrl'],
                                  ),
                                ),
                              ),
                            ),
                            Text(snapshot.data['title']),
                            Text(snapshot.data['date']),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> changeToSeenNotification(Auth user, String documentId) async {
    await FirebaseFirestore.instance
        .collection('ordernotification')
        .doc(user.userId)
        .collection('Notifications')
        .doc(documentId)
        .update({
      'orderBy': orderBy,
      'prodId': prodId,
      'seen': 'true',
    });
  }
}
