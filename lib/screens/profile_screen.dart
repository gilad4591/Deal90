import 'package:finalproject/providers/profile.dart';
import 'package:finalproject/models/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);
  static const routeName = '/edit-profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isLoading = true;
  final _formKey = GlobalKey<FormBuilderState>();
  final snackBar = SnackBar(content: Text('Profile updated successfully'));

  Future<void> _saveForm() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (_formKey.currentState.saveAndValidate()) {
      print(_formKey.currentState.value);

      await Firestore.instance
          .collection('users')
          .document(auth.userId)
          .updateData({
        'date': _formKey.currentState.value['date'].toString(),
        'city': _formKey.currentState.value['City'].toString(),
        'phone': _formKey.currentState.value['Phone'].toString(),
        'name': _formKey.currentState.value['Name'].toString(),
      });
    }
    //Navigator.of(context).pop();
    // ignore: deprecated_member_use
  }

  var currentLoggedInProfile = {
    'city': '',
    'date': '',
    'email': '',
    'name': '',
    'phone': '',
  };
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

    var now = DateTime.now();
    var today = new DateTime(now.year, now.month, now.day);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      currentLoggedInProfile['email'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    FormBuilderTextWidget(
                      attributeTextField: 'Name',
                      isEnabled: true,
                      initValue: currentLoggedInProfile['name'],
                    ),
                    FormBuilderTextWidget(
                      attributeTextField: 'City',
                      isEnabled: true,
                      initValue: currentLoggedInProfile['city'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      child: FormBuilderDateTimePicker(
                        attribute: "date",
                        inputType: InputType.date,
                        firstDate: today,
                        format: DateFormat("dd-MM-yyyy"),
                        //initialDate: DateTime(initValues['date']),
                        decoration: InputDecoration(
                          labelText: "Event date",
                          labelStyle: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    FormBuilderTextWidget(
                      attributeTextField: 'Phone',
                      isEnabled: true,
                      initValue: currentLoggedInProfile['phone'],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class FormBuilderTextWidget extends StatelessWidget {
  final String attributeTextField;
  final bool isEnabled;
  final String initValue;
  const FormBuilderTextWidget({
    Key key,
    this.attributeTextField,
    this.isEnabled,
    this.initValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(initValue);
    return FormBuilderTextField(
      attribute: attributeTextField,
      initialValue: initValue,
      decoration: InputDecoration(
        labelText: attributeTextField,
        labelStyle: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
      enabled: isEnabled,
      validators: [FormBuilderValidators.required()],
    );
  }
}
