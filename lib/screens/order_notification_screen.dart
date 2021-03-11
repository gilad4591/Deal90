import 'package:finalproject/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/models/auth.dart';

class OrderNotificationScreen extends StatefulWidget {
  const OrderNotificationScreen({Key key}) : super(key: key);
  static const routeName = '/order-notification';

  @override
  _OrderNotificationScreenState createState() =>
      _OrderNotificationScreenState();
}

class _OrderNotificationScreenState extends State<OrderNotificationScreen> {
  var _isLoading = true;

  var currentLoggedInProfile = {
    'city': '',
    'date': '',
    'email': '',
    'name': '',
    'phone': '',
  };

  Future<void> readData() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final db = Firestore.instance;
    await db.collection('users').document(auth.userId).get().then(
      (DocumentSnapshot documentSnapshot) {
        currentLoggedInProfile.update('city', (v) {
          return documentSnapshot.data['city'];
        });
        currentLoggedInProfile.update('date', (v) {
          return documentSnapshot.data['date'];
        });
        currentLoggedInProfile.update('name', (v) {
          return documentSnapshot.data['name'];
        });
        currentLoggedInProfile.update('email', (v) {
          return documentSnapshot.data['email'];
        });
        currentLoggedInProfile.update('phone', (v) {
          return documentSnapshot.data['phone'];
        });
      },
    );
    if (_isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    readData();

    return (_isLoading)
        ? CircularProgressIndicator()
        : Scaffold(
            body: Column(
              children: [
                Text(
                    "This screen will show in the future the last ordered deals that bought from current user."),
                Text(currentLoggedInProfile['email']),
              ],
            ),
            appBar: AppBar(
              title: Text('Deal90'),
            ),
            drawer: AppDrawer(),
          );
  }
}
