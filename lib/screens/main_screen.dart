import 'package:flutter/material.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/screens/order_notification_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

var _isLoading = true;
var currentLoggedInProfile = {
  'city': '',
  'date': '',
  'email': '',
  'name': '',
  'phone': '',
};

class _MainScreenState extends State<MainScreen> {
  Future<void> readData() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final db = Firestore.instance;
    await db.collection('users').document(auth.userId).get().then(
      (DocumentSnapshot documentSnapshot) {
        currentLoggedInProfile.update('city', (v) {
          return documentSnapshot.data['city'];
        });
        currentLoggedInProfile.update('date', (v) {
          return documentSnapshot.data['date'];
        });
        currentLoggedInProfile.update('name', (v) {
          return documentSnapshot.data['name'];
        });
        currentLoggedInProfile.update('email', (v) {
          return documentSnapshot.data['email'];
        });
        currentLoggedInProfile.update('phone', (v) {
          return documentSnapshot.data['phone'];
        });
      },
    );
    if (_isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    readData();
    // if (_isLoading) {
    //   CircularProgressIndicator();
    // }
    return (_isLoading)
        ? CircularProgressIndicator()
        : Scaffold(
            body: Column(
              children: <Widget>[
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 232,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF3383CD),
                          Color(0xFF11249F),
                        ],
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/party.png"),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Color(0xFFE5E5E5),
                    ),
                  ),
                  child: Center(
                    child: currentLoggedInProfile['name'].length > 0
                        ? Text(
                            "Welcome Back " + currentLoggedInProfile['name'],
                            textAlign: TextAlign.center,
                          )
                        : Text("Welcome"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ButtonMain('First Button'),
                        SizedBox(
                          width: 20,
                          height: 20,
                        ),
                        ButtonMain('Second Button'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: ButtonMain('Notification'),
                          onTap: () {
                            print("clicked");
                            Navigator.of(context).pushReplacementNamed(
                                OrderNotificationScreen.routeName);
                          },
                        ),
                        SizedBox(
                          width: 20,
                          height: 20,
                        ),
                        ButtonMain('Fourth Button'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            appBar: AppBar(
              title: Text('Deal90'),
            ),
            drawer: AppDrawer(),
          );
  }
}

class ButtonMain extends StatelessWidget {
  final String textButton;
  const ButtonMain(this.textButton, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 180,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3383CD),
              Color(0xFF11249F),
              Colors.black,
              // Colors.white,
              // Colors.blue,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            textButton,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
    //  <Widget>[
    // Text(textButton),
    // ],
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
