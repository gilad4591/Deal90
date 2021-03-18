import 'package:finalproject/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final creatorProfile = {
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

    print(creatorProfile['name']);
    // return creatorProfile['name'].length > 0 ?
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
    return ElevatedButton(
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
        height: 100,
        width: 100,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name: ' + creatorProfile['name'],
                  ),
                  Text(
                    'Email: ' + creatorProfile['email'],
                  ),
                  Text(
                    'Phone: ' + creatorProfile['phone'],
                  ),
                  Text(
                    'City: ' + creatorProfile['city'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
