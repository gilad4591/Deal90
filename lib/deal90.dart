import 'package:finalproject/loginF/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class Deal90App extends StatelessWidget {
  const Deal90App({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: LoginPage(),
    );
  }
}
