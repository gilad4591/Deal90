import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class SearchQuery extends StatelessWidget {
  SearchQuery({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  final region = {'Jerusalem', 'Northern', 'Central', 'Southern'};

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.filter_alt),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FormBuilderDateTimePicker(
                                attribute: "date",
                                inputType: InputType.date,
                                // firstDate: today,
                                format: DateFormat("dd-MM-yyyy"),
                                //initialDate: today,
                                decoration: InputDecoration(
                                  labelText: "Event date",
                                  labelStyle: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            FormBuilderChoiceChip(
                              attribute: 'category',
                              decoration: InputDecoration(
                                labelText: 'Select a category',
                              ),
                              options: [
                                FormBuilderFieldOption(
                                    value: 'Music', child: Text('Music')),
                                FormBuilderFieldOption(
                                    value: 'Photography',
                                    child: Text('Photography')),
                                FormBuilderFieldOption(
                                    value: 'Other', child: Text('Other')),
                              ],
                            ),
                            FormBuilderDropdown(
                              attribute: 'region',
                              decoration: InputDecoration(
                                labelText: 'Region',
                              ),
                              allowClear: true,
                              iconEnabledColor: Colors.blue,
                              iconDisabledColor: Colors.grey,
                              clearIcon: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                              hint: Text('Select region'),
                              items: region
                                  .map(
                                    (region) => DropdownMenuItem(
                                      value: region,
                                      child: Text('$region'),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      Navigator.pop(context, _formKey);
                                    }
                                    print(_formKey.currentState.value);
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
    // child: Text("Open Popup"),});
  }
}
