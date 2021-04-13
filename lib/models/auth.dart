import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  FirebaseAuth auth;
  bool get isAuth {
    return token != null;
  }

  final _auth = FirebaseAuth.instance;

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB_ImEcGl5PrubtLAMqVKCmxO5r3jZBMM0';
    AuthResult authResult;
    try {
      if (urlSegment == 'signInWithPassword')
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      // final response = await http.post(
      //   url,
      //   body: json.encode(
      //     {
      //       'email': email,
      //       'password': password,
      //       'returnSecureToken': true,
      //     },
      //   ),
      // );
      // final responseData = json.decode(response.body);
      // if (responseData['error'] != null) {
      //   throw HttpException(responseData['error']['message']);
      // }
      // _token = responseData['idToken'];
      // _userId = responseData['localId'];
      // _expiryDate = DateTime.now().add(
      //   Duration(
      //     seconds: int.parse(responseData['expiresIn']),
      //   ),
      // );

      final tokenResult = await FirebaseAuth.instance.currentUser();
      final idToken = await tokenResult.getIdToken();
      _token = idToken.token;
      print(_token);
      print(authResult.user.uid);
      _userId = authResult.user.uid;
      _expiryDate = DateTime.now().add(Duration(
        minutes: 30,
      ));
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
