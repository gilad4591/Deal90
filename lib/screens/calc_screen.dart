import 'package:flutter/material.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:finalproject/strings.dart';
import 'package:intl/intl.dart' as intl;

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

  String enteredText = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // myController.dispose();
    super.dispose();
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
              //controller: myController,
              textAlign: TextAlign.right,
              onChanged: (newText) {
                enteredText = newText;
              },
              cursorColor: Theme.of(context).cursorColor,
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
              textDirection: TextDirection.rtl,
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              textAlign: TextAlign.right,
              cursorColor: Theme.of(context).cursorColor,
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.favorite),
                labelText: 'אחוז האורחים',
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
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              textAlign: TextAlign.right,
              cursorColor: Theme.of(context).cursorColor,
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.favorite),
                labelText: 'יום בשבוע',
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
                    onTap: () {},
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
