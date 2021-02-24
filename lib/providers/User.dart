import 'package:cloud_firestore/cloud_firestore.dart';
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
    this.userId,
    this.date,
  });

  // Map<String, dynamic> toJson() => {
  //       'email': email,
  //       'name': name,
  //       'city': city,
  //       'phoneNumber': phoneNumber,
  //       'date': date,
  //     };

  // User.fromSnapshot(DocumentSnapshot snapshot) {
  //   email = snapshot['email'];
  //   name = snapshot['name'];
  //   city = snapshot['city'];
  //   phoneNumber = snapshot['phoneNumber'];
  //   date = snapshot['date'];
  // }
}
