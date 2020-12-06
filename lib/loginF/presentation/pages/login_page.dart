import 'package:custom_navigator/custom_navigator.dart';
import 'package:dartz/dartz.dart';
import 'package:finalproject/core/entities/user.dart';
import 'package:finalproject/loginF/presentation/state_managment/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/loginF/core/loginfailure.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomNavigator(
      navigatorKey:
          Provider.of<LoginProvider>(context, listen: false).navigatorKey,
      pageRoute: PageRoutes.materialPageRoute,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Header(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              LoginWithGoogle(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.Google,
      elevation: 5,
      text: "Sign up with Google",
      onPressed: () async {
        await Provider.of<LoginProvider>(context, listen: false)
            .signInWithGoogle();
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      child: SvgPicture.asset("lib/core/assets/weddingCouple.svg"),
    );
  }
}
