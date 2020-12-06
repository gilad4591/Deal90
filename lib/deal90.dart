import 'package:finalproject/loginF/presentation/pages/login_page.dart';
import 'package:finalproject/loginF/presentation/state_managment/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Deal90App extends StatelessWidget {
  final GlobalKey<NavigatorState> _mainNavigatorKey =
      GlobalKey<NavigatorState>();
  Deal90App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
      ],
      child: MaterialApp(
        navigatorKey: _mainNavigatorKey,
        home: LoginPage(),
      ),
    );
  }
}
