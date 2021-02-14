import 'package:flutter/material.dart';

class User {
  String email;
  String name;
  String city;
  String phoneNumber;
  String date;
  String userId;

  User({
    @required this.email,
    @required this.name,
    @required this.city,
    @required this.phoneNumber,
    @required this.userId,
    this.date,
  });
}
