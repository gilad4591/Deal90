import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/models/auth.dart';
import 'package:finalproject/widgets/app_drawer.dart';
import 'package:finalproject/widgets/products_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum FilterOptions {
  Favorites,
  All,
  ForMe,
}

final _formKey = GlobalKey<FormBuilderState>();

final region = {'Jerusalem', 'Northern', 'Central', 'Southern'};

class ProductOveviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';
  @override
  _ProductOveviewScreenState createState() => _ProductOveviewScreenState();
}

class _ProductOveviewScreenState extends State<ProductOveviewScreen> {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  var _showOnlyFavorites = false;
  var filterByCategory = false;
  var filterByDate = false;
  var filterByRegion = false;
  var _isInit = true;
  var _isLoading = false;
  var date;
  var category;
  var regionF;

  String userDateString;

  @override
  void initState() {
    super.initState();


  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    // save dealer's date
     FirebaseFirestore.instance.doc('users/${FirebaseAuth.instance.currentUser.uid}')
        .get().then((snapshot) {
       userDateString = snapshot.get('date');
     });



    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal90'),
        actions: <Widget>[
          IconButton(
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
                                      format: DateFormat("dd/MM/yyyy"),
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
                                          value: 'music', child: Text('Music')),
                                      FormBuilderFieldOption(
                                          value: 'photography',
                                          child: Text('Photography')),
                                      FormBuilderFieldOption(
                                          value: 'makeup',
                                          child: Text('Makeup')),
                                      FormBuilderFieldOption(
                                          value: 'hairdesign',
                                          child: Text('Hair design')),
                                      FormBuilderFieldOption(
                                          value: 'dressing',
                                          child: Text('Dressing')),
                                      FormBuilderFieldOption(
                                          value: 'other', child: Text('Other')),
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
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            if (_formKey.currentState
                                                    .value['category'] !=
                                                null) {
                                              setState(() {
                                                category = _formKey.currentState
                                                    .value['category'];
                                                filterByCategory = true;
                                                print(_formKey.currentState
                                                    .value['category']);
                                                print(filterByCategory);
                                              });
                                            } else {
                                              setState(() {
                                                filterByCategory = false;
                                              });
                                            }
                                            if (_formKey.currentState
                                                    .value['date'] !=
                                                null) {
                                              var dateForm = _formKey
                                                  .currentState.value['date'];
                                              var formattedDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(dateForm);
                                              print(formattedDate);
                                              date = formattedDate.toString();
                                              filterByDate = true;
                                            } else {
                                              filterByDate = false;
                                            }
                                            Navigator.pop(context);
                                          }
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) async {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;

                }
                else if(selectedValue == FilterOptions.ForMe){


                  date = userDateString;
                  filterByDate = true;
                }
                else {
                  _showOnlyFavorites = false;
                  filterByDate = false;
                }


              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show Deals For me'),
                value: FilterOptions.ForMe,
              ),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavorites, category, filterByCategory, date,
                filterByDate),
      ),
    );
  }
}
