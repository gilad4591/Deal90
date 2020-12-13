import 'package:flutter/material.dart';

import 'components/body.dart';
import 'package:finalproject/screens/sign_in/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
