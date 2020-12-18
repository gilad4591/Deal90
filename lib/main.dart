import 'package:flutter/material.dart';
import './screens/product_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) => Products(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.blueAccent,
          fontFamily: 'Muli',
        ),
        home: ProductOveviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}
