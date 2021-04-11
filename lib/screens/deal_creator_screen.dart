import 'package:finalproject/models/screen_arguments.dart';
import 'package:finalproject/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/app_drawer.dart';
import 'nm_box.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  args.creatorName,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Text(
                  args.creatorCity,
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 15),
                Text(
                  args.bio ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: NMButton(
                        icon: FontAwesomeIcons.facebookF,
                        color: args.creatorFacebookURL != null
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onTap: () {
                        _launchURL(args.creatorFacebookURL);
                      },
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      child: NMButton(
                        icon: FontAwesomeIcons.whatsapp,
                        color: args.creatorPhone != null
                            ? Colors.lightGreenAccent[400]
                            : Colors.grey,
                      ),
                      onTap: () {
                        _launchURL('https://wa.me/972' +
                            args.creatorPhone
                                .substring(1, args.creatorPhone.length - 1));
                      },
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                      child: NMButton(
                        icon: FontAwesomeIcons.instagram,
                        color: args.creatorInstagramURL != null
                            ? Colors.pink[400]
                            : Colors.grey,
                      ),
                      onTap: () {
                        _launchURL(args.creatorInstagramURL);
                      },
                    ),
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
  final String creatorName;
  final String creatorCity;
  final String creatorPhone;
  final String creatorInstagramURL;
  final String creatorFacebookURL;
  final String creatorEmail;
  final String bio;

  ScreenArguments(
      this.creatorName,
      this.creatorCity,
      this.creatorPhone,
      this.creatorInstagramURL,
      this.creatorFacebookURL,
      this.creatorEmail,
      this.bio);
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
            SizedBox(width: 3),
            Text(
              category,
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
  final Color color;
  const NMButton({
    this.icon,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: nMbox,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}

_launchURL(String url) async {
  print('entered launch url');
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print(url);
    return;
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
