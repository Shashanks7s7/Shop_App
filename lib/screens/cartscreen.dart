import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/providers/order.dart';

import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartdata = Provider.of<Cart>(
      context,
    );
    final orderdata = Provider.of<Order>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Spacer(),
                  Chip(
                      backgroundColor: Theme.of(context).accentColor,
                      label: Text("Rs.${cartdata.totalamount}")),
                  SizedBox(width: 10),
                  OrderButton(cartdata: cartdata, orderdata: orderdata)
                ]),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
              itemCount: cartdata.items.length,
              itemBuilder: (context, index) => CartItem(
                    cartdata.items.values.toList()[index].id,
                    cartdata.items.keys.toList()[index],
                    cartdata.items.values.toList()[index].price,
                    cartdata.items.values.toList()[index].quantity,
                    cartdata.items.values.toList()[index].title,
                  )),
        ),
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartdata,
    required this.orderdata,
  }) : super(key: key);

  final Cart cartdata;
  final Order orderdata;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading=false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: (widget.cartdata.totalamount<=0 || isLoading) ?null: () async{
          setState(() {
            isLoading=true;
          });
          await widget.orderdata.addorder(widget.cartdata.items.values.toList(),
              widget.cartdata.totalamount);
          setState(() {
            isLoading=false;
          });
          widget.cartdata.clear();
         
          // Navigator.of(context).pushNamed('orderScreen');
        },
        child: isLoading?CircularProgressIndicator(): Text(
          "Order Now",
          style: TextStyle(color: Theme.of(context).accentColor),
        ));
  }
}
