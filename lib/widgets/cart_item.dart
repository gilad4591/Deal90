import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String title;

  const CartItem(this.id, this.price, this.title);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Text(double.parse('$price').toStringAsFixed(2)),
            ),
          ),
          title: Text(title),
        ),
      ),
    );
  }
}
