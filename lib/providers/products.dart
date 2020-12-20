import 'package:finalproject/providers/product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Photographer',
      description: '2 image photographers, 1 video',
      imageUrl:
          'https://rationalbelief.org.il/wp-content/uploads/2019/01/photographer-3672010__340.jpg',
      originalPrice: 2500,
      dealPrice: 2300,
      date: "1.1.2020",
    ),
    Product(
      id: 'p2',
      title: 'Dj',
      description: 'Dj for event',
      imageUrl:
          'https://data.1freewallpapers.com/detail/dj-music-disco-installation.jpg',
      originalPrice: 2300,
      dealPrice: 2000,
      date: "1.1.2020",
    ),
    Product(
      id: 'p3',
      title: 'Make up',
      description: 'make up for bride',
      imageUrl:
          'https://www.bps.org.uk/sites/www.bps.org.uk/files/News/News%20-%20Images/Makeup.jpg',
      originalPrice: 2400,
      dealPrice: 1800,
      date: "1.1.2020",
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      dealPrice: product.dealPrice,
      originalPrice: product.originalPrice,
      description: product.description,
      date: product.date,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
