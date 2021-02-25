import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class Profile with ChangeNotifier {
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

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

  Future<void> fetchAndSetProfile() async {
    //final auth = Provider.of<Auth>(context, listen: false);
  }

  Future saveEventOnFireStore(SeatMeAppEvents eventToSave) async {
    // var firebaseUser = FirebaseAuth.instance.currentUser;
    // CollectionReference events = firestoreInstance
    //     .collection("users")
    //     .doc(firebaseUser.uid)
    //     .collection('Events');
    // final docRef = events.doc();
    // docRef
    //     .set({
    //       'EventName': eventToSave.eventName,
    //       'eventDate': eventToSave.eventDate,
    //       'numberOfGuests': eventToSave.numberOfGuests,
    //       'numOfChairsOnTable': eventToSave.numOfChairsOnTable
    //     })
    //     .then((value) => value)
    //     .catchError((error) => print("Failed to add user: $error"));
    // currentEvent.eventId = docRef.id;
  }
}
