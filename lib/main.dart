import 'package:flutter/material.dart';
import './screens/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.deepOrange,
        fontFamily: 'Muli',
      ),
      home: ProductOveviewScreen(),
    );
  }
}
