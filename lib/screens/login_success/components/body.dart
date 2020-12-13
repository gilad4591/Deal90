import 'package:finalproject/screens/sign_in/components/body.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/components/default_button.dart';
import 'package:finalproject/screens/home/home_screen.dart';
import 'package:finalproject/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Welcome " + displayNameGoogleSignIn()),
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Center(
          child: Text(
            "Login Success",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }

  String displayNameGoogleSignIn() {
    return (googleSignIn.currentUser != null
        ? googleSignIn.currentUser.displayName
        : null);
  }
}
