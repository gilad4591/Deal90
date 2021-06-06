import 'package:finalproject/providers/product.dart';
import 'package:finalproject/providers/products.dart';
import 'package:finalproject/utils/fcm/send_push.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    'instagram_url': '',
    'facebook_url': '',
    'bio': '',
    'profileImageURL': '',
  };
  var _isloading = true;

  Future<void> loadProfile(String creatorId) async {
    final db = FirebaseFirestore.instance;
    await db.collection('users').doc(creatorId).get().then(
      (DocumentSnapshot documentSnapshot) {
        creatorProfile.update('id', (v) {
          return creatorId;
        });
        creatorProfile.update('city', (v) {
          return documentSnapshot.get('city');
        });
        creatorProfile.update('date', (v) {
          return documentSnapshot.get('date');
        });
        creatorProfile.update('name', (v) {
          return documentSnapshot.get('name');
        });
        creatorProfile.update('email', (v) {
          return documentSnapshot.get('email');
        });
        creatorProfile.update('phone', (v) {
          return documentSnapshot.get('phone');
        });
        creatorProfile.update('instagram_url', (v) {
          return documentSnapshot.get('instagram_url');
        });
        creatorProfile.update('facebook_url', (v) {
          return documentSnapshot.get('facebook_url');
        });
        creatorProfile.update('bio', (v) {
          return documentSnapshot.get('bio');
        });
        creatorProfile.update('profileImageURL', (v) {
          return documentSnapshot.get('profileImageURL');
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
                ? CreatorDetailsButton(
                    creatorProfile: creatorProfile,
                    loadedProduct: loadedProduct)
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
    @required this.loadedProduct,
  }) : super(key: key);

  final Product loadedProduct;
  final Map<String, String> creatorProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: ElevatedButton(
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
            child: Text("Rate Me!"),
          ),
        ),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Theme.of(context).buttonColor),
                ),
              ),
            ),
            onPressed: () async {
              /// Send A push to the Deal's creator
              // final dealCreatorId =
              //     "d-Uej_9ZQV6dtc1RlFKn89:APA91bHgrT_kVTpVW2kUo-Uced0iplaHu3N5Y3_aBqjiM-YFSQJuRctKY_tUpOhGZYUs0f5WUrmEEAocsJqBKu9-a2ifJTha_11jTjtspU_AKsWuG147rditxi1F-QF6l7Jvi1Wmhu6p";

              FirebaseDatabase.instance
                  .reference()
                  .child('fcmTokens/${creatorProfile['id']}/tokens')
                  .once()
                  .then((snapshot) async {
                for (String id in snapshot.value) {
                  final dealCreatorId = id;

                  var response = await SendPush.to(dealCreatorId,
                      title: "A new user ordered your deal!",
                      body: "Check out who it is",
                      dataMap: {
                        'type': 'user-order',
                      },
                      imageUrl: loadedProduct.imageUrl);

                  print(response.statusCode);
                }
              });

              /// Change it's status to PENDING
            },
            child: Text("Order Now!"),
          ),
        ),
        SizedBox(
          width: 200,
          child: ElevatedButton(
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
                arguments: ScreenArguments(
                  creatorProfile['id'],
                  creatorProfile['name'],
                  creatorProfile['city'],
                  creatorProfile['phone'],
                  creatorProfile['instagram_url'],
                  creatorProfile['facebook_url'],
                  creatorProfile['email'],
                  creatorProfile['bio'],
                  creatorProfile['profileImageURL'],
                ),
              );
            },
            child: Text("  Deal Creator Card "),
          ),
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
        height: MediaQuery.of(context).size.height * 0.15,
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
  // var _ratingController;
  double _rating;
  double _initialRating = 0;
  int _numberOfRaters = 0;
  bool _isVertical = false;

  var _isLoading = true;
  final snackBar = SnackBar(
    content: Text('You have rated this user succesfully!'),
  );
  final snackBarFailed = SnackBar(
    content: Text('You are unable to rate.\n please try again later.'),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    // _ratingController = TextEditingController(text: '0.0');
    _rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    readRatingData(widget.creatorProfile);
    final auth = Provider.of<Auth>(context, listen: false);

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
                  if (auth.token != null) {
                    setState(() {
                      _rating = rating;
                      rateUser(widget.creatorProfile);
                    });
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    // ScaffoldMessenger.of(context).showSnackBar(snackBarFailed);
                  }
                  Navigator.pop(context);
                },

                // updateOnDrag: true,
              ),
              Text('Number of raters: ' + _numberOfRaters.toString()),
            ],
          );
  }

  Future<void> readRatingData(Map<String, String> creatorProfile) async {
    var averageRating = 0.0;
    // ignore: unused_local_variable
    var sumRating;
    var numberRaters = 0;
    // ignore: unused_local_variable
    var myRating = -1.0;
    final auth = Provider.of<Auth>(context, listen: false);
    final dbGeneralRating = FirebaseFirestore.instance;
    final dbMyRating = FirebaseFirestore.instance;
    print(creatorProfile['id']);
    await dbGeneralRating
        .collection('userRating')
        .doc(creatorProfile['id'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        averageRating = double.parse(documentSnapshot['average']);
        sumRating = double.parse(documentSnapshot['sum']);
        try {
          print(numberRaters);
          print(numberRaters);

          numberRaters = int.tryParse(documentSnapshot['numberRaters']);
          print(numberRaters);
          // print(documentSnapshot['numberRaters']);
        } on Exception catch (error) {
          print(error);
        }
      }
    });
    if (numberRaters > 0) {
      await dbMyRating
          .collection('userRating')
          .doc(creatorProfile['id'])
          .collection('raters')
          .doc(auth.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          myRating = double.parse(documentSnapshot.get('rate'));
        }
      });
    }
    if (_isLoading) {
      setState(() {
        if (averageRating > 0) {
          _initialRating = averageRating;
          _numberOfRaters = numberRaters;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> rateUser(Map<String, String> creatorProfile) async {
    final auth = Provider.of<Auth>(context, listen: false);
    var oldRating = 0.0;
    var newRating = _rating;
    // ignore: unused_local_variable
    var averageRating = 0.0;
    var sumRating = 0.0;
    var numberRaters = 0;
    var createNewDoc = false;

    final dbGeneralRating = FirebaseFirestore.instance;
    final dbMyRating = FirebaseFirestore.instance;
    print(creatorProfile['id']);
    await dbGeneralRating
        .collection('userRating')
        .doc(creatorProfile['id'])
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot);
        averageRating = double.parse(documentSnapshot['average']);
        sumRating = double.parse(documentSnapshot['sum']);
        numberRaters = int.parse(documentSnapshot['numberRaters']);
      }
    });
    if (numberRaters > 0) {
      await dbMyRating
          .collection('userRating')
          .doc(creatorProfile['id'])
          .collection('raters')
          .doc(auth.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          oldRating = double.parse(documentSnapshot['rate']);
        }
      });
    } else {
      createNewDoc = true;
    }
    if (oldRating > 0) {
      await FirebaseFirestore.instance
          .collection('userRating')
          .doc(creatorProfile['id'])
          .collection('raters')
          .doc(auth.userId)
          .update({
        'rate': (_rating).toString(),
      });
    } else {
      numberRaters++;
      await FirebaseFirestore.instance
          .collection('userRating')
          .doc(creatorProfile['id'])
          .collection('raters')
          .doc(auth.userId)
          .set({
        'rate': (_rating).toString(),
      });
    }
    if (!createNewDoc) {
      await FirebaseFirestore.instance
          .collection('userRating')
          .doc(creatorProfile['id'])
          .update({
        'sum': (sumRating - oldRating + _rating).toString(),
        'average':
            ((sumRating - oldRating + newRating) / numberRaters).toString(),
        'numberRaters': (numberRaters).toString(),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('userRating')
          .doc(creatorProfile['id'])
          .set({
        'sum': (sumRating - oldRating + _rating).toString(),
        'average':
            ((sumRating - oldRating + newRating) / numberRaters).toString(),
        'numberRaters': (numberRaters).toString(),
      });
    }
  }
}
