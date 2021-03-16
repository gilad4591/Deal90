import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/models/auth.dart';

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
      mainAxisAlignment: MainAxisAlignment.start,
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
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: Firestore.instance
                    .collection('users')
                    .document(orderBy)
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 100.0),
                              child: Column(
                                children: [
                                  Text(
                                    'New order!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: 25.0,
                                    height: 25.0,
                                    buttonColor: Colors.white,
                                    child: RaisedButton(
                                      onPressed: () {
                                        changeToSeenNotification(
                                            user, documentId);
                                      },
                                      child: Icon(Icons.check),
                                    ),
                                  ),
                                  Text("Mark as read"),
                                ],
                              ),
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
      ],
    );
  }

  Future<void> changeToSeenNotification(Auth user, String documentId) async {
    await Firestore.instance
        .collection('ordernotification')
        .document(user.userId)
        .collection('Notifications')
        .document(documentId)
        .updateData({
      'orderBy': orderBy,
      'prodId': prodId,
      'seen': 'true',
    });
  }
}
