import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      onPressed: () {},
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
