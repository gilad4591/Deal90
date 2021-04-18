import 'package:flutter/material.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRatersScreen extends StatefulWidget {
  MyRatersScreen({Key key}) : super(key: key);
  static const routeName = '/my-raters';

  @override
  _MyRatersScreenState createState() => _MyRatersScreenState();
}

class _MyRatersScreenState extends State<MyRatersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShowMyRating(),
        ],
      ),
      appBar: AppBar(
        title: Text('Deal90'),
      ),
      drawer: AppDrawer(),
    );
  }
}

class ShowMyRating extends StatefulWidget {
  const ShowMyRating({Key key}) : super(key: key);

  @override
  _ShowMyRatingState createState() => _ShowMyRatingState();
}

class _ShowMyRatingState extends State<ShowMyRating> {
  var _isLoading = true;
  double _rating;
  double _initialRating = 0;
  int _numberOfRaters = 0;
  var _raterListToShow = [];
  var _ratingListToShow = [];
  var _raterListNamesToShow = [];
  @override
  void initState() {
    super.initState();
    _rating = _initialRating;
  }

  Future<void> readRatingData() async {
    var averageRating = 0.0;
    var raterList = [];
    var ratingList = [];
    // ignore: unused_local_variable
    var sumRating;
    var numberRaters = 0;
    // ignore: unused_local_variable
    var myRating = -1.0;
    final auth = Provider.of<Auth>(context, listen: false);
    final dbGeneralRating = Firestore.instance;
    final dbRaters = Firestore.instance;
    await dbGeneralRating
        .collection('userRating')
        .document(auth.userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null) {
        averageRating = double.parse(documentSnapshot['average']);
        sumRating = double.parse(documentSnapshot['sum']);
        numberRaters = int.parse(documentSnapshot['numberRaters']);
      }
    });
    if (numberRaters > 0) {
      await dbRaters
          .collection('userRating')
          .document(auth.userId)
          .collection('raters')
          .getDocuments()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.documents.forEach((doc) async {
          String rater = doc.documentID;
          // print(rater);
          if (!raterList.contains(rater)) {
            raterList.add({
              rater,
            });
            ratingList.add(doc['rate']);
            await getRaterName(rater);
          }
        });
      });
    }
    if (_isLoading) {
      setState(() {
        if (averageRating > 0) {
          _raterListToShow = raterList;
          _ratingListToShow = ratingList;
          _initialRating = averageRating;
          _numberOfRaters = numberRaters;
          if (_raterListNamesToShow.length == _raterListToShow.length) {
            _isLoading = false;
          }
        } else {
          _isLoading = false;
        }
      });
    }
  }

  Future<void> getRaterName(String rater) async {
    final dbRaterProfile = Firestore.instance;

    await dbRaterProfile
        .collection('users')
        .document(rater)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null && _isLoading) {
        setState(() {
          _raterListNamesToShow.add({(documentSnapshot['name'])});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readRatingData();
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _initialRating > 0
                    ? Column(
                        children: [
                          Text(
                            "Your Average Rating is:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyCurrentRating(initialRating: _initialRating),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Text(
                            'Number of raters: ' + _numberOfRaters.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _raterListToShow.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.star,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        _raterListNamesToShow[index]
                                            .toString()
                                            .replaceAll('}', '')
                                            .replaceAll('{', ''),
                                      ),
                                      trailing: Text(
                                        _ratingListToShow[index].toString(),
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : NothingOrderedYet(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
  }
}

class MyCurrentRating extends StatelessWidget {
  const MyCurrentRating({
    Key key,
    @required double initialRating,
  })  : _initialRating = initialRating,
        super(key: key);

  final double _initialRating;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < _initialRating ? Icons.star : Icons.star_border,
            color: Colors.blue,
          );
        }),
      ),
    );
  }
}

class ShowMyRaters extends StatelessWidget {
  const ShowMyRaters({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NothingOrderedYet extends StatelessWidget {
  const NothingOrderedYet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "You didn't rated yet.",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
