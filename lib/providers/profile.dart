import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  String email;
  String name;
  String city;
  String phone;
  String date;
  String userId;

  Profile({
    this.email,
    this.name,
    this.city,
    this.phone,
    this.userId,
    this.date,
  });
}
