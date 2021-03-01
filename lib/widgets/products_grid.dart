import 'package:finalproject/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/widgets/product_item.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  final bool isFilterByCategory;
  final String categoryFilter;
  ProductsGrid(
      this.showFavorites, this.categoryFilter, this.isFilterByCategory);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productsFav =
        showFavorites ? productsData.favoriteItems : productsData.items;
    final products = isFilterByCategory
        ? (productsFav.where((i) => i.category == categoryFilter).toList())
        : productsFav;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
