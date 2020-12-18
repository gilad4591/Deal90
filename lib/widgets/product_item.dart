import 'package:finalproject/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.dealPrice.toString() + ' NIS',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'muli',
                backgroundColor: Colors.black,
              ),
            ),
            Text(
              product.originalPrice.toString() + ' NIS',
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.lineThrough,
                fontFamily: 'muli',
                backgroundColor: Colors.black54,
              ),
            ),
          ],
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              product.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
