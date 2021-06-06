import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMMessage {
  final String title;
  final String body;
  final Map data;

  FCMMessage({this.title, this.body, this.data});

  FCMMessage.fromMap(Map map)
      : title = map['notification']['title'],
        body = map['notification']['body'],
        data = map['data'];
}

class MessageHandler extends StatefulWidget {
  final Widget child;

  const MessageHandler({@required this.child});

  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    _initLocalNotifications();

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
        FCMUtils.saveDeviceToken();

        FCMUtils.subscribeToTopics();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      FCMUtils.saveDeviceToken();

      FCMUtils.subscribeToTopics();
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        var msg = FCMMessage.fromMap(message);

        // show in background
        _showNotificationWithDefaultSound(msg.body, msg.body);
      },
      onLaunch: (Map<String, dynamic> message) async {
        var msg = FCMMessage.fromMap(message);

        // go to the right Event
      },
      onResume: (Map<String, dynamic> message) async {
        var msg = FCMMessage.fromMap(message);

        // go to the right Event
        print("OnResume");
      },
      onBackgroundMessage: _firebaseMessagingBackgroundHandler,
    );
  }

  @override
  void dispose() {
    if (iosSubscription != null) {
      iosSubscription.cancel();
    }
    super.dispose();
  }

  _initLocalNotifications() {
    var android = AndroidInitializationSettings('@drawable/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<void> _onSelectNotification(String payload) async {
    //Navigator.push(context, );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(
    Map<String, dynamic> message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  var msg = FCMMessage(
    title: message['data']['title'],
    body: message['data']['body'],
    data: message['data'],
  );

  _showNotificationWithDefaultSound(msg.title, msg.body);
}

class FCMUtils {
  const FCMUtils._();

  /// Get the token, save it to the database for current user
  static void saveDeviceToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

    auth.User currUser = _auth.currentUser;

    // Get the current user
    String uid = currUser.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firebase Database
    if (fcmToken != null) {
      var tokenRef =
          FirebaseDatabase.instance.reference().child("fcmTokens/$uid");

      await tokenRef.updateArrayUnion('tokens', [fcmToken]);

      // await tokenRef.update({
      //   'tokens': FieldValue.arrayUnion([fcmToken])
      //   // 'token': fcmToken,
      //   // 'createdAt': , // optional
      //   // 'platform': Platform.operatingSystem // optional
      // });
    }
  }

  static Future<void> removeDeviceToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

    auth.User currUser = _auth.currentUser;

    // Get the current user
    String uid = currUser.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firebase Database
    if (fcmToken != null) {
      var tokenRef =
          FirebaseDatabase.instance.reference().child("fcmTokens/$uid");

      await tokenRef.updateArrayRemove('tokens', [fcmToken]);
    }
  }

  /// Subscribe to the user's topics
  static void subscribeToTopics() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    try {
      String uid = auth.FirebaseAuth.instance.currentUser.uid;
      var userSnapshot =
          await FirebaseFirestore.instance.doc('users/$uid').get();
      List<String> topics =
          (userSnapshot.get('fcmTopics') ?? []).cast<String>();

      for (var topic in topics) {
        _fcm.subscribeToTopic(topic);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Unsubscribe from a topic
  static void unsubscribeFromTopic(String topic) async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    _fcm.unsubscribeFromTopic(topic);

    String uid = auth.FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.doc('users/$uid').update({
      "fcmTopics": FieldValue.arrayRemove([topic])
    });
  }

  /// subscribe from a topic
  static void subscribeToTopic(String topic) async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    _fcm.subscribeToTopic(topic);

    String uid = auth.FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.doc('users/$uid').update({
      "fcmTopics": FieldValue.arrayUnion([topic])
    });
  }
}

//
//
Future _showNotificationWithDefaultSound(String title, String message) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'abc', 'channel_name', 'channel_description',
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
      importance: Importance.max,
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    message,
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

extension DatabaseReferenceExtension on DatabaseReference {
  updateArrayRemove(String fieldPath, List elements) async {
    List list = [];

    var snapshot = await this.child(fieldPath).once();

    if (snapshot.value != null) {
      if (!(snapshot.value is List)) {
        return;
      } else {
        list.addAll(snapshot.value as List);
      }
    }

    list.removeWhere((el) => elements.contains(el));

    this.update({fieldPath: list});
  }

  updateArrayUnion(String fieldPath, List elements) async {
    List list = [];

    var snapshot = await this.child(fieldPath).once();

    if (snapshot.value != null) {
      if (!(snapshot.value is List)) {
        return;
      } else {
        list.addAll(snapshot.value as List);
      }
    }

    list.addAll(elements);

    this.update({fieldPath: list.toSet().toList()});
  }
}
