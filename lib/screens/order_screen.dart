import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {


  

  @override
  Widget build(BuildContext context) {
// final orderdata = Provider.of<Order>(context);
    return Scaffold(
        drawer: Draw(),
        appBar: AppBar(
          title: Text('Order Items'),
          centerTitle: true,
        ),
        body: FutureBuilder(future: Provider.of<Order>(context,listen: false).fetchdata(),
        builder: (context,snapshot)=>
          snapshot.hasError? Center(child:Text("No any order placement.")):
          Consumer<Order>(
                builder: (ctx, orderdata, child) =>
 ListView.builder(
            itemCount: orderdata.items.length,
            itemBuilder: (context, index) {
              return OrderItem(orderdata.items[index]);
            }))));
            
        
        
    
  }
}
