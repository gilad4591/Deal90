import 'package:flutter/material.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:finalproject/strings.dart';
import 'package:math_expressions/math_expressions.dart';
//import 'package:intl/intl.dart' as intl;

class CalcScreen extends StatefulWidget {
  CalcScreen({Key key}) : super(key: key);
  static const routeName = '/calc';

  @override
  _CalcScreenState createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  //TextEditingController pNumController = new TextEditingController();
  //TextEditingController numOfDrinkersContoller = new TextEditingController();
  //TextEditingController dayController = new TextEditingController();

  String numfOfguests = '';
  String percentOfDrinkers = '';
  String finalSol = '';
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  String alcoholCalc(String numOfgue, String perecentOdrinkers) {
    Parser p = new Parser();
    Expression exp = p.parse("$numfOfguests*($percentOfDrinkers/100)");
    String result = exp
        .evaluate(EvaluationType.REAL, null)
        .toString(); // if context is not available replace it with null.
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'מחשבון אלכוהול לחתונה',
          textDirection: TextDirection.rtl,
        ),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: ListView(children: <Widget>[
          Text(
            alcohol_Open_Alert,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              key: _formKey1,
              //controller: myController,
              textAlign: TextAlign.right,
              onChanged: (newText) {
                numfOfguests = newText;
              },
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.favorite),
                labelText: 'כמה אורחים?',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
              /*validator: (value) {
                if (value.isEmpty || value == null) {
                  return 'הכנס כמות אורחים תקינה';
                }
                if (double.tryParse(value) == null) {
                  return 'הכנס מספר תקין';
                }
                if (double.tryParse(value) <= 0) {
                  return 'מספר האורחים צריך להיות גדול מ 0';
                }
                return 'הכנס קלט תקין';
              },
              */
              textDirection: TextDirection.rtl,
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              key: _formKey2,
              textAlign: TextAlign.right,
              cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
              maxLength: 20,
              onChanged: (newText) {
                percentOfDrinkers = newText;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.favorite),
                labelText: 'אחוז האורחים השותים',
                labelStyle: TextStyle(
                  color: Color(0xFF6200EE),
                ),
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),
              ),
              textDirection: TextDirection.rtl,
              /*validator: (value) {
                if (value.isEmpty || value == null) {
                  return 'הכנס כמות אורחים תקינה';
                }
                if (double.tryParse(value) == null) {
                  return 'הכנס מספר תקין';
                }
                if (double.tryParse(value) <= 0) {
                  return 'מספר האורחים צריך להיות גדול מ 0';
                }
                return null;
              },
              */
            ),
          ),
          Column(
            children: <Widget>[
              ClipOval(
                child: Material(
                  color: Colors.blue, // button color
                  child: InkWell(
                    splashColor: Colors.red, // inkwell color
                    child: SizedBox(
                        width: 86,
                        height: 86,
                        child: Icon(Icons.calculate_sharp)),
                    onTap: () {
                      /*if (!(_formKey1.currentState.validate() &&
                          _formKey2.currentState.validate())) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("הכנס מס אורחים ואחוז תקינים")));
                      }
                      */

                      finalSol = alcoholCalc(numfOfguests, percentOfDrinkers);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("כמות האלכוהול המשוערת",
                                textDirection: TextDirection.rtl),
                            content: new Text(
                              "$finalSol ליטר",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("תודה"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}