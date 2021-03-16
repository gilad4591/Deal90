import 'package:finalproject/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/widgets/userNotification/notifications.dart';

class OrderNotificationScreen extends StatefulWidget {
  const OrderNotificationScreen({Key key}) : super(key: key);
  static const routeName = '/order-notification';

  @override
  _OrderNotificationScreenState createState() =>
      _OrderNotificationScreenState();
}

class _OrderNotificationScreenState extends State<OrderNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Notifications(),
            ),
          ],
        ),
      ),
    );
  }
}
