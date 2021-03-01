import 'package:finalproject/widgets/app_drawer.dart';
import 'package:finalproject/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

enum FilterOptions {
  Favorites,
  All,
}
enum FilterCategory {
  Music,
  Photography,
  Other,
  All,
}

class ProductOveviewScreen extends StatefulWidget {
  @override
  _ProductOveviewScreenState createState() => _ProductOveviewScreenState();
}

class _ProductOveviewScreenState extends State<ProductOveviewScreen> {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  var filterByCategory = false;
  var category;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deal90'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterCategory selectedValue) {
              setState(() {
                if (selectedValue
                        .toString()
                        .compareTo(FilterCategory.Music.toString()) ==
                    0) {
                  filterByCategory = true;
                  category = 'music';
                } else if (selectedValue
                        .toString()
                        .compareTo(FilterCategory.Photography.toString()) ==
                    0) {
                  filterByCategory = true;
                  category = 'photography';
                } else if (selectedValue
                        .toString()
                        .compareTo(FilterCategory.Other.toString()) ==
                    0) {
                  filterByCategory = true;
                  category = 'other';
                } else if (selectedValue
                        .toString()
                        .compareTo(FilterCategory.All.toString()) ==
                    0) {
                  filterByCategory = false;
                  category = '';
                } else {
                  filterByCategory = false;
                  category = null;
                }
              });
            },
            icon: Icon(
              Icons.filter_alt,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Music'), value: FilterCategory.Music),
              PopupMenuItem(
                  child: Text('Photography'),
                  value: FilterCategory.Photography),
              PopupMenuItem(child: Text('Other'), value: FilterCategory.Other),
              PopupMenuItem(child: Text('All'), value: FilterCategory.All),
            ],
          ),
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
            : ProductsGrid(_showOnlyFavorites, category, filterByCategory),
      ),
    );
  }
}
