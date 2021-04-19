import 'package:finalproject/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/providers/orders.dart' show Orders;
import '../widgets//order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;
  Future _obteinOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obteinOrdersFuture();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          print(dataSnapshot.hasData);
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
              return
                  // dataSnapshot.hasData
                  // ? {
                  Consumer<Orders>(
                builder: (ctx, orderData, child) => orderData.orders.isNotEmpty
                    ? ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      )
                    : NothingOrderedYet(),
              );
            // }
            // : NothingOrderedYet();
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
