import 'package:finalproject/models/auth.dart';
import 'package:finalproject/screens/product_overview_screen.dart';
import 'package:google_fonts/google_fonts.dart';
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
      var date;
      if (_formKey.currentState.value['date'] is DateTime) {
        date = DateFormat("dd/MM/yyyy")
            .format(_formKey.currentState.value['date']);
      }
      await Firestore.instance
          .collection('users')
          .document(auth.userId)
          .updateData({
        'date': date,
        'city': _formKey.currentState.value['City'].toString(),
        'phone': _formKey.currentState.value['Phone'].toString(),
        'name': _formKey.currentState.value['Name'].toString(),
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductOveviewScreen()),
      );
    }
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
    DateTime date;
    if (currentLoggedInProfile['date'] != null) {
      if (!_isLoading) {
        if (currentLoggedInProfile['date'].length > 1)
          date = parseDateFormat(currentLoggedInProfile['date']);
      }
    } else {
      date = null;
    }

    var now = DateTime.now();
    var today = new DateTime(now.year, now.month, now.day);
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
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
          : Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  //color: Colors.grey[200],
                  child: Text(
                    'Email: ' + currentLoggedInProfile['email'],
                    style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              // color: Colors.black.withOpacity(0.2),
                              // spreadRadius: 5,
                              // blurRadius: 7,
                              // offset: Offset(0, 3),
                              ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
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
                                  format: DateFormat("dd/MM/yyyy"),
                                  initialValue: date,
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
                                  isPhone: true),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  DateTime parseDateFormat(String currentLoggedInProfile) {
    String curr = currentLoggedInProfile;
    var inputFormat = new DateFormat('dd/MM/yyyy');
    var date1 = inputFormat.parse(curr);
    var outputFormat = DateFormat("yyyy-MM-dd");
    return outputFormat.parse("$date1");
  }
}

class FormBuilderTextWidget extends StatelessWidget {
  final String attributeTextField;
  final bool isEnabled;
  final String initValue;
  final bool isPhone;
  const FormBuilderTextWidget({
    Key key,
    this.attributeTextField,
    this.isEnabled,
    this.initValue,
    this.isPhone = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phonePattern = r'^(05)?[0-9]{8}$';
    var patternNotSpecialChars = r'^[a-zA-Z-]+(?:\s[a-zA-Z-]+)?$';
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
      validators: [
        isPhone
            ? FormBuilderValidators.pattern(phonePattern,
                errorText: 'Please enter a valid phone number')
            : FormBuilderValidators.pattern(patternNotSpecialChars,
                errorText:
                    'Please do not use special charecters or multiple spaces.'),
        FormBuilderValidators.minLength(5,
            errorText: 'Length should be at least 5 characters'),
        FormBuilderValidators.maxLength(20,
            errorText: 'Length should be 20 characters at most'),
      ],
    );
  }
}
