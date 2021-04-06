import 'package:finalproject/providers/orders.dart';
import 'package:finalproject/screens/deal_creator_screen.dart';
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
import 'models/auth.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/order_notification_screen.dart';
import 'screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Colors.blueAccent,
            fontFamily: 'Muli',
          ),
          home: auth.isAuth ? MainScreen() : AuthScreen(),
          routes: {
            MainScreen.routeName: (ctx) => MainScreen(),
            ProductOveviewScreen.routeName: (ctx) => ProductOveviewScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            DealCreatorScreen.routname: (ctx) => DealCreatorScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
            OrderNotificationScreen.routeName: (ctx) =>
                OrderNotificationScreen(),
          },
        ),
      ),
    );
  }
}
