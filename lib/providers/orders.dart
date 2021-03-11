// mange orders
import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://finalproject-52a7e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    var response = await http.get(url);
    // print(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    if (extractedData == null) {
      _orders = loadedOrders;
      notifyListeners();
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['totalPrice'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['product'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  title: item['title'],
                  creator: item['creator'],
                  productId: item['productId'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProuducts, double total) async {
    final url =
        'https://finalproject-52a7e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'totalPrice': total,
          'dateTime': timeStamp.toIso8601String(),
          'product': cartProuducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'creator': cp.creator,
                    'productId': cp.productId,
                  })
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProuducts,
      ),
    );
    for (int i = 0; i < cartProuducts.length; i++) {
      print(cartProuducts[i].creator);
      await Firestore.instance
          .collection('ordernotification')
          .document(cartProuducts[i].creator)
          .collection('Notifications')
          .document()
          .setData({
        'orderBy': userId,
        'prodId': cartProuducts[i].productId,
        'seen': 'false',
      });
    }
    notifyListeners();
  }
}
