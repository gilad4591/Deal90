// import 'package:finalproject/providers/User.dart';
// import 'package:finalproject/models/auth.dart';
// import 'package:finalproject/models/http_exception.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {
//   ProfileScreen({Key key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   var _isLoading = false;
//   final _nameFocusNode = FocusNode();
//   final _emailFocusNode = FocusNode();
//   final _userIdFocusNode = FocusNode();
//   final _dateFocusNode = FocusNode();
//   final _phoneNumberFocusNode = FocusNode();
//   final _cityFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();

//   var _editedProfile = User(
//     userId: null,
//     email: '',
//     city: '',
//     phoneNumber: '',
//     name: '',
//     date: '',
//   );
//   var _isInit = true;
//   var _initValues = {
//     'userId': '',
//     'phone': '',
//     'email': '',
//     'city': '',
//     'name': '',
//     'date': '',
//   };

//   @override
//   void dispose() {
//     _phoneNumberFocusNode.dispose();
//     _cityFocusNode.dispose();
//     _dateFocusNode.dispose();
//     _emailFocusNode.dispose();
//     _userIdFocusNode.dispose();
//     super.dispose();
//   }

//   void initState() {
//     {
//       super.initState();
//     }
//   }

//   Future<void> _saveForm() async {
//     final auth = Provider.of<Auth>(context, listen: false);
//     final DocumentReference collectionReference =
//         Firestore.instance.document('users/$auth.userId');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveForm,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _form,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       TextFormField(
//                         initialValue: _initValues['email'],
//                         decoration: InputDecoration(labelText: 'Email'),
//                         textInputAction: TextInputAction.next,
//                         onFieldSubmitted: (_) {
//                           FocusScope.of(context)
//                               .requestFocus(_originalPriceFocusNode);
//                         },
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please enter a title';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           _editedProfile = User(
//                               title: value,
//                               id: _editedProduct.id,
//                               description: _editedProduct.description,
//                               originalPrice: _editedProduct.originalPrice,
//                               dealPrice: _editedProduct.dealPrice,
//                               imageUrl: _editedProduct.imageUrl,
//                               date: _editedProduct.date,
//                               category: _editedProduct.category);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
