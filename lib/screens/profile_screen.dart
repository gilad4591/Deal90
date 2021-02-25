import 'package:finalproject/providers/profile.dart';
import 'package:finalproject/models/auth.dart';
import 'package:finalproject/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);
  static const routeName = '/edit-profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>().provider;

  Future<void> _saveForm() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (_formKey.currentState.saveAndValidate()) {
      print(_formKey.currentState.value);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: Provider.of<Profile>(context, listen: false).fbKey,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextWidget(
                        attributeTextField: 'Email', isEnabled: false),
                    FormBuilderTextWidget(
                        attributeTextField: 'Name', isEnabled: true),
                    FormBuilderTextWidget(
                        attributeTextField: 'City', isEnabled: true),
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
                        decoration: InputDecoration(
                          labelText: "Event date",
                        ),
                      ),
                    ),
                    FormBuilderTextWidget(
                        attributeTextField: 'Phone', isEnabled: true),
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
  const FormBuilderTextWidget({
    Key key,
    this.attributeTextField,
    this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      attribute: '$attributeTextField',

      // initialValue: _initValues['email'],
      decoration: InputDecoration(labelText: '$attributeTextField'),
      enabled: isEnabled,
      validators: [FormBuilderValidators.required()],
    );
  }
}
