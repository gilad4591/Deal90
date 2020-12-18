import 'package:finalproject/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOveviewScreen extends StatefulWidget {
  @override
  _ProductOveviewScreenState createState() => _ProductOveviewScreenState();
}

class _ProductOveviewScreenState extends State<ProductOveviewScreen> {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal90'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
