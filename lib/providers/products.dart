import 'package:finalproject/providers/product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'photographer',
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
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  void addProduct() {
    //_items.add(value);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
