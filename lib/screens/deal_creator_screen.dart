import 'package:finalproject/models/screen_arguments.dart';
import 'package:finalproject/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/app_drawer.dart';
import 'nm_box.dart';

class DealCreatorScreen extends StatelessWidget {
  static const routeName = '/creator-card';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Deal Creator Card'),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AvatarImage(),
                SizedBox(height: 15),
                Text(
                  args.creator_name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Text(
                  args.creator_city,
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 15),
                Text(
                  'Mobile App Developer and Game Designer',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    NMButton(icon: FontAwesomeIcons.facebookF),
                    SizedBox(
                      width: 25,
                    ),
                    NMButton(icon: FontAwesomeIcons.whatsapp),
                    SizedBox(width: 25),
                    NMButton(icon: FontAwesomeIcons.instagram),
                  ],
                ),
                Spacer(),
                SizedBox(height: 20),
                SizedBox(height: 20),
                SizedBox(height: 35),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final String creator_name;
  final String creator_city;
  final String creator_phone;
  final String instagram_url;
  final String facebook_url;

  ScreenArguments(this.creator_name, this.creator_city, this.creator_phone,
      this.instagram_url, this.facebook_url);
}

class SocialBox extends StatelessWidget {
  final IconData icon;
  final String count;
  final String category;

  const SocialBox({this.icon, this.count, this.category});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: nMboxInvert,
        child: Row(
          children: <Widget>[
            FaIcon(icon, color: Colors.pink.shade800, size: 20),
            SizedBox(width: 8),
            Text(
              count,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 3),
            Text(
              category,
            ),
          ],
        ),
      ),
    );
  }
}

class NMButton extends StatelessWidget {
  final IconData icon;
  const NMButton({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: nMbox,
      child: Icon(
        icon,
        color: fCL,
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.all(8),
      decoration: nMbox,
      child: Container(
        decoration: nMbox,
        padding: EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/Deal90Logo2.png'),
            ),
          ),
        ),
      ),
    );
  }
}
