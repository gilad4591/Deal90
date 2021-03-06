import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:finalproject/models/screen_arguments.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 145,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                var copy = false;
                ScreenArguments screenArguments = new ScreenArguments(copy, id);
                print(screenArguments);
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: screenArguments);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                var copy = true;
                ScreenArguments screenArguments = new ScreenArguments(copy, id);

                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: screenArguments);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  // ignore: deprecated_member_use
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      'Deleting failed',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
