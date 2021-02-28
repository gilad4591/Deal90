import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Profile with ChangeNotifier {
  // final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

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
  // CollectionReference users = Firestore.instance.collection('users');

  // Profile getUserProfile(String userId) {
  //   final db = Firestore.instance;
  //   db.collection('users').document(userId).get().then(
  //     (DocumentSnapshot documentSnapshot) {
  //       // Get value of field date from document dashboard/totalVisitors
  //       Profile initValues;
  //       initValues.city = documentSnapshot.data['city'];
  //       initValues.date = documentSnapshot.data['date'];
  //       initValues.email = documentSnapshot.data['email'];
  //       initValues.name = documentSnapshot.data['name'];
  //       initValues.phone = documentSnapshot.data['phone'];
  //       return initValues;
  //     },
  //   );
  //   return null;
  // }

  // Future<void> updateUser(String userId) {
  //   return users
  //       .document(userId)
  //       .updateData({'company': 'Stokes and Sons'})
  //       .then((value) => print("User Updated"))
  //       .catchError((error) => print("Failed to update user: $error"));
  // }

  Future<void> fetchAndSetProfile() async {
    //final auth = Provider.of<Auth>(context, listen: false);
  }
}
