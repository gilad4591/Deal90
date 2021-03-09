import 'package:flutter/material.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return Scaffold(
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
        ],
      ),
      appBar: AppBar(
        title: Text('Deal90'),
      ),
      drawer: AppDrawer(),
    );
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
