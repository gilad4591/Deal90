import 'package:finalproject/providers/orders.dart';
import 'package:finalproject/screens/deal_creator_screen.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'screens/deal_recommendations_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/order_notification_screen.dart';
import 'screens/main_screen.dart';
import 'screens/my_raters.dart';
import 'utils/fcm/message_handler.dart' as fcm;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

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
            auth.userId ?? '',
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(builder: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId ?? '',
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          Widget home;
          switch(auth.authState){

            case AuthState.NOT_LOGGED_IN:
              home =  AuthScreen();
              break;
            case AuthState.NOT_REGISTERED:
              home = ProfileScreen(fromStart: true);
              break;
            case AuthState.LOGGED_IN:
              auth.updateToken();
              home = fcm.MessageHandler(child: MainScreen());
              break;
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.blueAccent,
              fontFamily: 'Muli',
            ),
            home: home,
            // home: auth.isAuth
            //     ? fcm.MessageHandler(child: MainScreen())
            //     : AuthScreen(),
            routes: {
              MainScreen.routeName: (ctx) => MainScreen(),
              ProductOveviewScreen.routeName: (ctx) => ProductOveviewScreen(),
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              DealCreatorScreen.routeName: (ctx) => DealCreatorScreen(),
              ChatScreen.routeName: (ctx) => ChatScreen(),
              MyRatersScreen.routeName: (ctx) => MyRatersScreen(),
              OrderNotificationScreen.routeName: (ctx) =>
                  OrderNotificationScreen(),
              DealRecommendationsScreen.routeName: (ctx) =>
                  DealRecommendationsScreen(),
            },
          );
        },
      ),
    );
  }
}
