import 'package:finalproject/providers/orders.dart';
import 'package:flutter/material.dart';
import './screens/product_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => Cart(),
        ),
        ChangeNotifierProvider.value(value: Orders())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.blueAccent,
          fontFamily: 'Muli',
        ),
        home: ProductOveviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
