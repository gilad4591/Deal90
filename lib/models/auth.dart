import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/http_exception.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthState{
  NOT_REGISTERED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  FirebaseAuth auth;
  bool isRegistered = false;



  // bool get isAuth {
  //   return _auth.currentUser != null;
  //   // return token != null;
  // }

  AuthState get authState {
    if(_auth.currentUser == null)
      return AuthState.NOT_LOGGED_IN;

    if(!isRegistered)
      return AuthState.NOT_REGISTERED;

    return AuthState.LOGGED_IN;
  }

  final _auth = FirebaseAuth.instance;

  Future<void> _checkIfRegistered()async {
    var snapshot = await FirebaseFirestore.instance.doc(
        'users/${_auth.currentUser.uid}').get();
    isRegistered = snapshot.exists;
    notifyListeners();
  }


  Auth() {
    updateToken();
    if(_auth.currentUser != null)
      _checkIfRegistered();
  }

  String get userId {
    return _auth.currentUser?.uid ?? "";
  }

  /// fetch token for first use
  Future<void> updateToken() async{
    if(_token == null && authState == AuthState.LOGGED_IN){
      final tokenResult = FirebaseAuth.instance.currentUser;
      final idToken = await tokenResult.getIdTokenResult();//getIdToken();
      _token = idToken.token;
      _expiryDate = idToken.expirationTime;
      notifyListeners();
    }
  }

  String get token{
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    // final url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB_ImEcGl5PrubtLAMqVKCmxO5r3jZBMM0';


    UserCredential authResult;
    try {
      if (urlSegment == 'signInWithPassword')
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

        var snapshot = await FirebaseFirestore.instance.doc('users/${authResult.user.uid}').get();
        if(!snapshot.exists){
          isRegistered = false;
          notifyListeners();
          return;
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

      final tokenResult = FirebaseAuth.instance.currentUser;
      final idToken = await tokenResult.getIdTokenResult();//getIdToken();
      // TODO: CHECKKK
      _token = idToken.token;
      _userId = authResult.user.uid;
      _expiryDate = idToken.expirationTime;
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
    // await _auth.createUserWithEmailAndPassword(
    //     email: email, password: password);


    // if(_auth.currentUser == null)
    //   return false;
    //
    // var x = await FirebaseFirestore.instance.doc('users/${_auth.currentUser.uid}').get();
    // return x.exists;


  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    await _auth.signOut();
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
