import 'package:finalproject/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:finalproject/screens/deal_creator_screen.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:finalproject/models/auth.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final creatorProfile = {
    'id': '',
    'city': '',
    'date': '',
    'email': '',
    'name': '',
    'phone': '',
  };
  var _isloading = true;

  Future<void> loadProfile(String creatorId) async {
    final db = Firestore.instance;
    await db.collection('users').document(creatorId).get().then(
      (DocumentSnapshot documentSnapshot) {
        creatorProfile.update('id', (v) {
          return creatorId;
        });
        creatorProfile.update('city', (v) {
          return documentSnapshot.data['city'];
        });
        creatorProfile.update('date', (v) {
          return documentSnapshot.data['date'];
        });
        creatorProfile.update('name', (v) {
          return documentSnapshot.data['name'];
        });
        creatorProfile.update('email', (v) {
          return documentSnapshot.data['email'];
        });
        creatorProfile.update('phone', (v) {
          return documentSnapshot.data['phone'];
        });
      },
    );
    if (_isloading) {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String; //id
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    loadProfile(loadedProduct.creatorId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Price: ${loadedProduct.dealPrice} NIS',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${loadedProduct.date}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'More details:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                '${loadedProduct.description}',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 50),
            !_isloading
                ? CreatorDetailsButton(creatorProfile: creatorProfile)
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class CreatorDetailsButton extends StatelessWidget {
  const CreatorDetailsButton({
    Key key,
    @required this.creatorProfile,
  }) : super(key: key);

  final Map<String, String> creatorProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: Theme.of(context).buttonColor),
              ),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CreatorDetailsDialog(creatorProfile: creatorProfile);
              },
            );
          },
          child: Text("Deal creator details"),
        ),
        ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: Theme.of(context).buttonColor),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
              DealCreatorScreen.routeName,
              arguments: creatorProfile,
            );
          },
          child: Text("  Deal Creator Card "),
        )
      ],
    );
  }
}

class CreatorDetailsDialog extends StatelessWidget {
  const CreatorDetailsDialog({
    Key key,
    @required this.creatorProfile,
  }) : super(key: key);

  final Map<String, String> creatorProfile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0.0,
              top: 0.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.blue[900],
                  radius: 15,
                ),
              ),
            ),
            Center(
              child:
                  DisplayCreatorDetailsWidget(creatorProfile: creatorProfile),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayCreatorDetailsWidget extends StatelessWidget {
  const DisplayCreatorDetailsWidget({
    Key key,
    @required this.creatorProfile,
  }) : super(key: key);

  final Map<String, String> creatorProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        creatorProfile['name'].length > 2
            ? Text(
                'Name: ' + creatorProfile['name'],
              )
            : Text(''),
        Text(
          'Email: ' + creatorProfile['email'],
        ),
        creatorProfile['phone'].length > 2
            ? Text(
                'Phone: ' + creatorProfile['phone'],
              )
            : Text(''),
        creatorProfile['city'].length > 2
            ? Text(
                'City: ' + creatorProfile['city'],
              )
            : Text(''),
        SizedBox(
          height: 20,
        ),
        RatingBarCreator(creatorProfile: creatorProfile),
      ],
    );
  }
}

class RatingBarCreator extends StatefulWidget {
  final Map<String, String> creatorProfile;
  const RatingBarCreator({Key key, this.creatorProfile}) : super(key: key);

  @override
  _RatingBarCreatorState createState() => _RatingBarCreatorState();
}

class _RatingBarCreatorState extends State<RatingBarCreator> {
  var _ratingController;
  double _rating;
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 0;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;
  var _isLoading = true;
  final snackBar = SnackBar(
    content: Text('You have rated this user succesfully!'),
  );

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '0.0');
    _rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    readRatingData(widget.creatorProfile);
    return _isLoading
        ? CircularProgressIndicator()
        : Column(
            children: [
              _initialRating > 0
                  ? Text("User's Average Rating:")
                  : Text('Rate this user for his first time'),
              RatingBar.builder(
                initialRating: _initialRating,
                direction: _isVertical ? Axis.vertical : Axis.horizontal,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.star,
                        color: Colors.blue[400],
                      );
                    case 1:
                      return Icon(
                        Icons.star,
                        color: Colors.blue[400],
                      );
                    case 2:
                      return Icon(
                        Icons.star,
                        color: Colors.blue[400],
                      );
                    case 3:
                      return Icon(
                        Icons.star,
                        color: Colors.blue[400],
                      );
                    case 4:
                      return Icon(
                        Icons.star,
                        color: Colors.blue[400],
                      );
                    default:
                      return Container();
                  }
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                    rateUser(widget.creatorProfile);
                  });
                  //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);
                },
                // updateOnDrag: true,
              ),
            ],
          );
  }

  Future<void> readRatingData(Map<String, String> creatorProfile) async {
    var currentRating = 0.0;
    var averageRating = 0.0;
    var sumRating;
    var numberRaters = 0;
    var myRating = -1.0;
    final auth = Provider.of<Auth>(context, listen: false);
    final dbGeneralRating = Firestore.instance;
    final dbMyRating = Firestore.instance;
    await dbGeneralRating
        .collection('userRating')
        .document(creatorProfile['id'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null) {
        averageRating = double.parse(documentSnapshot['average']);
        sumRating = double.parse(documentSnapshot['sum']);
        numberRaters = int.parse(documentSnapshot['numberRaters']);
      }
    });
    if (numberRaters > 0) {
      await dbMyRating
          .collection('userRating')
          .document(creatorProfile['id'])
          .collection('raters')
          .document(auth.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.data != null) {
          myRating = double.parse(documentSnapshot['rate']);
        }
      });
    }
    if (_isLoading) {
      setState(() {
        if (averageRating > 0) {
          _initialRating = averageRating;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> rateUser(Map<String, String> creatorProfile) async {
    final auth = Provider.of<Auth>(context, listen: false);
    var oldRating = 0.0;
    var newRating = _rating;
    var averageRating = 0.0;
    var sumRating = 0.0;
    var numberRaters = 0;
    var createNewDoc = false;

    final dbGeneralRating = Firestore.instance;
    final dbMyRating = Firestore.instance;
    await dbGeneralRating
        .collection('userRating')
        .document(creatorProfile['id'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null) {
        averageRating = double.parse(documentSnapshot['average']);
        sumRating = double.parse(documentSnapshot['sum']);
        numberRaters = int.parse(documentSnapshot['numberRaters']);
      }
    });
    if (numberRaters > 0) {
      await dbMyRating
          .collection('userRating')
          .document(creatorProfile['id'])
          .collection('raters')
          .document(auth.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.data != null) {
          oldRating = double.parse(documentSnapshot['rate']);
        }
      });
    } else {
      createNewDoc = true;
    }
    if (oldRating > 0) {
      await Firestore.instance
          .collection('userRating')
          .document(creatorProfile['id'])
          .collection('raters')
          .document(auth.userId)
          .updateData({
        'rate': (_rating).toString(),
      });
    } else {
      numberRaters++;
      await Firestore.instance
          .collection('userRating')
          .document(creatorProfile['id'])
          .collection('raters')
          .document(auth.userId)
          .setData({
        'rate': (_rating).toString(),
      });
    }
    if (!createNewDoc) {
      await Firestore.instance
          .collection('userRating')
          .document(creatorProfile['id'])
          .updateData({
        'sum': (sumRating - oldRating + _rating).toString(),
        'average':
            ((sumRating - oldRating + newRating) / numberRaters).toString(),
        'numberRaters': (numberRaters).toString(),
      });
    } else {
      await Firestore.instance
          .collection('userRating')
          .document(creatorProfile['id'])
          .setData({
        'sum': (sumRating - oldRating + _rating).toString(),
        'average':
            ((sumRating - oldRating + newRating) / numberRaters).toString(),
        'numberRaters': (numberRaters).toString(),
      });
    }
  }
}
