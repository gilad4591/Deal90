import 'package:dartz/dartz.dart';
import 'package:finalproject/feedF%20/presentation/pages/feed_page.dart';
import 'package:finalproject/loginF/core/share_preferences_names.dart';
import 'package:finalproject/loginF/presentation/pages/register_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:finalproject/core/entities/user.dart';
import 'package:finalproject/loginF/core/loginfailure.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  final GoogleSignIn googleSignIn;
  AppUser currentLoggedInUser = AppUser();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  LoginProvider()
      : _auth = FirebaseAuth.instance,
        googleSignIn = GoogleSignIn();

  Future<Either<AppUser, LoginFailure>> _signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    User user;
    UserCredential authResult;
    if (_auth.currentUser == null) {
      authResult = await _auth.signInWithCredential(credential);
      user = authResult.user;
    } else {
      user = _auth.currentUser;
    }

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      currentLoggedInUser.uid = user.uid;

      print('signInWithGoogle succeeded: $user');

      return Left(currentLoggedInUser);
    }

    return Right(LoginFailure());
  }

  Future signInWithGoogle() async {
    Either<AppUser, LoginFailure> result = await _signInWithGoogle();
    result.fold((AppUser user) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //if (prefs.getBool(FIRST_LOGGED_IN) == null) {
      await prefs.setBool(FIRST_LOGGED_IN, true);
      navigateToRegisterProfilePage();
      //} else {
      //navigateToToFeedPage();
      // }
    }, (LoginFailure) {
      print("Login Failed");
    });
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  void navigateToRegisterProfilePage() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => RegisterProfilePage(),
      ),
    );
  }

  void navigateToToFeedPage() {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => FeedPage(),
      ),
    );
  }
}
