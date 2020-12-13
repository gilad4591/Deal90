import 'package:flutter/material.dart';

class User {
  String displayName;
  String city;
  String userType;
  String phoneNumber;
  DateTime date;
  String email;
  String userId;

  User(
      {@required this.displayName,
      @required this.city,
      @required this.userType,
      @required this.phoneNumber,
      @required this.email,
      @required this.userId});
}
