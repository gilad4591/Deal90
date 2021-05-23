import 'package:finalproject/models/auth.dart';
import 'package:finalproject/screens/product_overview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/widgets/logout_after_expired.dart';

class ProfileScreen extends StatefulWidget {
  final bool fromStart;
  ProfileScreen({Key key, this.fromStart}) : super(key: key);
  static const routeName = '/edit-profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isLoading = true;
  File _pickedImage;
  final _formKey = GlobalKey<FormBuilderState>();

  void _pickImage() async {
    _isLoading = true;
    final pickedImageFile =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _isLoading = false;
      _pickedImage = pickedImageFile;
    });
  }

  Future<void> _saveForm() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (_formKey.currentState.saveAndValidate()) {
      var date;
      if (_formKey.currentState.value['date'] is DateTime) {
        date = DateFormat("dd/MM/yyyy")
            .format(_formKey.currentState.value['date']);
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(auth.userId + '.jpg');
      print(ref);
      var imageUrl = currentLoggedInProfile['profileImageURL'];
      if (_pickedImage != null) {
        await ref.putFile(_pickedImage).onComplete;
        imageUrl = await ref.getDownloadURL();
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.userId)
          .set({
        'email': auth.auth.currentUser.email,
        'date': date,
        'city': _formKey.currentState.value['City'].toString(),
        'phone': _formKey.currentState.value['Phone'].toString(),
        'name': _formKey.currentState.value['Name'].toString(),
        'facebook_url': _formKey.currentState.value['facebook_url'].toString(),
        'instagram_url':
            _formKey.currentState.value['instagram_url'].toString(),
        'bio': _formKey.currentState.value['bio'].toString(),
        'profileImageURL': imageUrl,
      }, SetOptions(merge: true));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductOveviewScreen()),
      );
    }
  }

  final _scrollController = ScrollController();

  var currentLoggedInProfile = {
    'city': '',
    'date': '',
    'email': '',
    'name': '',
    'phone': '',
    'facebook_url': '',
    'instagram_url': '',
    'bio': '',
    'profileImageURL': '',
  };
  Future<void> readData() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final db = FirebaseFirestore.instance;
    if (auth.token != null) {
      await db.collection('users').doc(auth.userId).get().then(
        (DocumentSnapshot documentSnapshot) {
          currentLoggedInProfile.update('city', (v) {
            return documentSnapshot.get('city');
          });
          currentLoggedInProfile.update('date', (v) {
            return documentSnapshot.get('date');
          });
          currentLoggedInProfile.update('name', (v) {
            return documentSnapshot.get('name');
          });
          currentLoggedInProfile.update('email', (v) {
            return documentSnapshot.get('email');
          });
          currentLoggedInProfile.update('phone', (v) {
            return documentSnapshot.get('phone');
          });
          currentLoggedInProfile.update('facebook_url', (v) {
            return documentSnapshot.get('facebook_url');
          });
          currentLoggedInProfile.update('instagram_url', (v) {
            return documentSnapshot.get('instagram_url');
          });
          currentLoggedInProfile.update('bio', (v) {
            return documentSnapshot.get('bio');
          });
          currentLoggedInProfile.update('profileImageURL', (v) {
            return documentSnapshot.get('profileImageURL');
          });
        },
      );
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    readData();
    DateTime date;
    final auth = Provider.of<Auth>(context, listen: false);
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
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      drawer: widget.fromStart!=null && widget.fromStart ? null: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scrollbar(
              thickness: 10,
              controller: _scrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: auth.userId == null
                    ? LogOutAlertDialog()
                    : Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: _pickedImage != null
                                ? FileImage(_pickedImage)
                                : NetworkImage(
                                    currentLoggedInProfile['profileImageURL'],
                                  ),
                          ),
                          FlatButton.icon(
                            textColor: Theme.of(context).primaryColor,
                            label: Text('Add Image'),
                            icon: Icon(Icons.image),
                            onPressed: _pickImage,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SingleChildScrollView(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FormBuilder(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          // FormBuilderTextWidget(
                                          //   icon: Icon(Icons.email),
                                          //   attributeTextField: 'Email',
                                          //   isEnabled: false,
                                          //   initValue:
                                          //       currentLoggedInProfile['email'],
                                          // ),
                                          FormBuilderTextWidget(
                                            icon: Icon(Icons.perm_identity),
                                            attributeTextField: 'Name',
                                            isEnabled: true,
                                            initValue:
                                                currentLoggedInProfile['name'],
                                          ),
                                          FormBuilderTextWidget(
                                            icon: Icon(Icons.location_city),
                                            attributeTextField: 'City',
                                            isEnabled: true,
                                            initValue:
                                                currentLoggedInProfile['city'],
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
                                                icon: Icon(Icons
                                                    .calendar_today_rounded),
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
                                            initValue:
                                                currentLoggedInProfile['phone'],
                                            isPhone: true,
                                            icon: Icon(Icons.phone),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          FormBuilderTextWidgetURL(
                                            attributeTextField: 'instagram_url',
                                            initValue: currentLoggedInProfile[
                                                'instagram_url'],
                                            labelTextField: 'Instagram URL',
                                            icon: Icon(
                                                FontAwesomeIcons.instagram),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          FormBuilderTextWidgetURL(
                                            attributeTextField: 'facebook_url',
                                            initValue: currentLoggedInProfile[
                                                'facebook_url'],
                                            labelTextField: 'Facebook URL',
                                            icon:
                                                Icon(FontAwesomeIcons.facebook),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          FormBuilderTextWidgetBio(
                                            attributeTextField: 'bio',
                                            initValue:
                                                currentLoggedInProfile['bio'],
                                            icon: Icon(Icons.contact_page),
                                            labelTextField: 'bio',
                                          ),
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
                          ),
                        ],
                      ),
              ),
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
  final Icon icon;
  const FormBuilderTextWidget({
    Key key,
    this.attributeTextField,
    this.isEnabled,
    this.initValue,
    this.isPhone = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phonePattern = r'^(05)?[0-9]{8}$';
    var patternNotSpecialChars = r'^[a-zA-Z-]+(?:\s[a-zA-Z-]+)?$';
    Color color;
    isEnabled ? color = Colors.blueAccent : color = Colors.grey;
    return FormBuilderTextField(
      attribute: attributeTextField,
      initialValue: initValue,
      decoration: InputDecoration(
        icon: icon,
        labelText: attributeTextField,
        labelStyle: TextStyle(
          color: color,
        ),
      ),
      readOnly: !isEnabled,
      validators: [
        isPhone
            ? FormBuilderValidators.pattern(phonePattern,
                errorText: 'Please enter a valid phone number')
            : FormBuilderValidators.pattern(patternNotSpecialChars,
                errorText:
                    'Please do not use special charecters or multiple spaces.'),
        FormBuilderValidators.minLength(3,
            errorText: ''
                'Length should be at least 5 characters'),
        FormBuilderValidators.maxLength(20,
            errorText: 'Length should be 20 characters at most'),
      ],
    );
  }
}

class FormBuilderTextWidgetURL extends StatelessWidget {
  final String attributeTextField;
  final String initValue;
  final String labelTextField;
  final Icon icon;
  const FormBuilderTextWidgetURL({
    Key key,
    this.attributeTextField,
    this.initValue,
    this.labelTextField,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var instaGram = r'^[a-zA-Z-]+(?:\s[a-zA-Z-]+)?$';

    return FormBuilderTextField(
      attribute: attributeTextField,
      initialValue: initValue,
      decoration: InputDecoration(
        icon: icon,
        labelText: labelTextField,
        labelStyle: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
      enabled: true,
      validators: [
        // FormBuilderValidators.pattern(instaGram, errorText: 'Enter valid url'),
        // FormBuilderValidators.url(errorText: 'Please enter valid url'),
      ],
    );
  }
}

class FormBuilderTextWidgetBio extends StatelessWidget {
  final String attributeTextField;
  final String initValue;
  final String labelTextField;
  final Icon icon;
  const FormBuilderTextWidgetBio({
    Key key,
    this.attributeTextField,
    this.initValue,
    this.labelTextField,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var patternNotSpecialChars = r'^[a-zA-Z0-9_\-\"=@,\.; ]+$';

    return FormBuilderTextField(
      attribute: attributeTextField,
      initialValue: initValue,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
        icon: icon,
        labelText: labelTextField,
        labelStyle: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
      enabled: true,
      validators: [
        // FormBuilderValidators.minLength(3,
        // errorText: 'Length should be at least 5 characters'),
        FormBuilderValidators.maxLength(200,
            errorText: 'Length should be 200 characters at most'),
        FormBuilderValidators.pattern(patternNotSpecialChars,
            errorText:
                'Please do not use special charecters or multiple spaces.'),
      ],
    );
  }
}
