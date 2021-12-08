import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order.dart' as pro;
class OrderItem extends StatefulWidget {
  final pro.OrderItems data;
  OrderItem(this.data);
 
  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
   bool expanded=false;
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds:300),
      height: expanded ? min(widget.data.product.length * 20.0 + 110, 200) : 95 ,
          child: Card(
margin: EdgeInsets.all(10),
  elevation: 5,
  child: Column(
      children: [
        ListTile(
          title:Text('\$${widget.data.amount}'),
            subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm').format(widget.data.time),
                  ),
                  trailing: IconButton(onPressed: (){
                    setState(() {
                      expanded=!expanded;
                    });
                  }, icon: Icon(!expanded? Icons.expand_more:Icons.expand_less)),
        ),
        
           AnimatedContainer(
             duration:Duration(milliseconds: 300),
                     
                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: expanded ? min(widget.data.product.length * 20.0 + 10, 100) : 0,
               child: ListView(
                 children: widget.data.product.map((e) => Row(
                   mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                children: [
                  Text(e.title,
                   style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                     Text("${e.quantity}x \$${e.price}",
                      style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    )),

  ]
                
                 )).toList(),
               
                  
             
        
      
             ),
           )]
)),
    );
  }
}