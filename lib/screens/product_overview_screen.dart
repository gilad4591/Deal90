import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductOveviewScreen extends StatelessWidget {
  final dateFormatter = DateFormat('dd-MM-yyyy');
  final List<Product> loadedProduct = [
    Product(
      id: 'p1',
      title: 'photographer',
      description: '2 image photographers, 1 video',
      imageUrl:
          'https://rationalbelief.org.il/wp-content/uploads/2019/01/photographer-3672010__340.jpg',
      price: 1500,
      date: "1.1.2020",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Deal90')),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProduct.length,
        itemBuilder: (ctx, i) => ProductItem(
          loadedProduct[i].id,
          loadedProduct[i].title,
          loadedProduct[i].price,
          loadedProduct[i].imageUrl,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
