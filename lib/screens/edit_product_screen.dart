import 'package:flutter/material.dart';
import 'package:finalproject/providers/product.dart';
import 'package:finalproject/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //final RegExp dateRegExp = new RegExp(r"/^");
  var _isLoading = false;
  final _originalPriceFocusNode = FocusNode();
  final _deal90PriceFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null,
      title: '',
      originalPrice: 0,
      dealPrice: 0,
      description: '',
      imageUrl: '',
      date: '');
  var _isInit = true;
  var _initValues = {
    'title': '',
    'originalPrice': '',
    'dealPrice': '',
    'description': '',
    'imageUrl': '',
    'date': ''
  };

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _originalPriceFocusNode.dispose();
    _deal90PriceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _dateFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    {
      super.initState();
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      // check if exsist a product/ deal:
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'originalPrice': _editedProduct.originalPrice.toString(),
          'dealPrice': _editedProduct.dealPrice.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
          'date': _editedProduct.date,
        };
        _imageUrlController.text = _editedProduct
            .imageUrl; // We used string because Textfield accept only Strings
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_originalPriceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value,
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              originalPrice: _editedProduct.originalPrice,
                              dealPrice: _editedProduct.dealPrice,
                              imageUrl: _editedProduct.imageUrl,
                              date: _editedProduct.date);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['originalPrice'],
                        decoration:
                            InputDecoration(labelText: 'Original Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _originalPriceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_deal90PriceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              originalPrice: double.parse(value),
                              dealPrice: _editedProduct.dealPrice,
                              imageUrl: _editedProduct.imageUrl,
                              date: _editedProduct.date);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.tryParse(value) <= 0) {
                            return 'Price should be greater than 0.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['dealPrice'],
                        decoration: InputDecoration(labelText: 'Deal 90 Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _deal90PriceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_dateFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              originalPrice: _editedProduct.originalPrice,
                              dealPrice: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              date: _editedProduct.date);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.tryParse(value) <= 0) {
                            return 'Price should be greater then 0.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['date'],
                        decoration: InputDecoration(labelText: 'Date'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.datetime,
                        focusNode: _dateFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              originalPrice: _editedProduct.originalPrice,
                              dealPrice: _editedProduct.dealPrice,
                              imageUrl: _editedProduct.imageUrl,
                              date: value);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a date.';
                          }
                          return null;
                        },
                      ),

                      //_dateFocusNode
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              description: value,
                              originalPrice: _editedProduct.originalPrice,
                              dealPrice: _editedProduct.dealPrice,
                              imageUrl: _editedProduct.imageUrl,
                              date: _editedProduct.date);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a Url')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    id: _editedProduct.id,
                                    description: _editedProduct.description,
                                    originalPrice: _editedProduct.originalPrice,
                                    dealPrice: _editedProduct.dealPrice,
                                    imageUrl: value,
                                    date: _editedProduct.date);
                              },
                              validator: (value) {
                                if (_imageUrlController.text.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                if (!_imageUrlController.text
                                        .startsWith('http') &&
                                    !_imageUrlController.text
                                        .startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!_imageUrlController.text
                                        .endsWith('.jpg') &&
                                    !_imageUrlController.text.endsWith('png') &&
                                    !_imageUrlController.text
                                        .endsWith('.jpeg')) {
                                  return 'Please enter a valid format image.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
