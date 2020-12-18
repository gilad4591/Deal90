import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //shows an error
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }
}
