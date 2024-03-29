import 'package:finalproject/models/auth.dart';
import 'package:finalproject/screens/profile_screen.dart';
import 'package:finalproject/screens/main_screen.dart';
import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import 'package:finalproject/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/screens/product_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome to DEAL90'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.home),
              title: Text('Main'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(MainScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ProfileScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Deals'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ProductOveviewScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
