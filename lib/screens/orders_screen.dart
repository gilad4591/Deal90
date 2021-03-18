import 'package:finalproject/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/providers/orders.dart' show Orders;
import '../widgets//order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred! please try again'),
              );
            } else
              return dataSnapshot.hasData
                  ? {
                      Consumer<Orders>(
                        builder: (ctx, orderData, child) => ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(orderData.orders[i]),
                        ),
                      )
                    }
                  : NothingOrderedYet();
          }
        },
      ),
    );
  }
}

class NothingOrderedYet extends StatelessWidget {
  const NothingOrderedYet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "You didn't order anything yet.",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
