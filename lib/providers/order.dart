import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop/providers/cart.dart';

class OrderItems {
  final String id;
  final List<CartItem> product;
  final double amount;
  final DateTime time;
  OrderItems(
      {required this.id,
      required this.product,
      required this.amount,
      required this.time});
}

class Order with ChangeNotifier {
  List<OrderItems> _items = [];
  List<OrderItems> get items {
    return [..._items];
  }
  String? _token;
  String? _userid;
  void orderlis(String tok,String user){
_token=tok;
_userid=user;
  }
  Future<void> fetchdata()async{
      var url =
        Uri.https('shopapp-d3dcd-default-rtdb.firebaseio.com', '/order/$_userid.json',{"auth":"$_token"});
    final response=await get(url);
        final productfetch= json.decode(response.body) as Map<String,dynamic>;
          if (productfetch==null){
          return;
        }
        final List<OrderItems>loadedcart=[];
      
        productfetch.forEach((index, value) { 
          loadedcart.add(
             OrderItems(id: index,  amount: value['amount'], time: DateTime.parse(value['time']) ,
             product:  ( value['product'] as List<dynamic>).map((e) =>
             CartItem(id: e['id'], title: e['title'], quantity: e['quantity'], price: e['price']),
           ).toList(),
          )
          );
          _items=loadedcart.reversed.toList();
          notifyListeners();
        });
  }

  Future<void> addorder(List<CartItem> pro, double amount) async {
    var url =
        Uri.https('shopapp-d3dcd-default-rtdb.firebaseio.com', '/order/$_userid.json',{'auth':'$_token'});
        final timestamp=DateTime.now();
        final response=await post(url,body: json.encode({
          'amount':amount,
          'time':timestamp.toIso8601String(),
          'product':pro.map((e) => {
            'id':e.id,
            'title':e.title,
            'quantity':e.quantity,
            'price':e.price,
          }).toList()
        }));
    _items.insert(
        0,
        OrderItems(
            id: json.decode(response.body)['name'],
            amount: amount,
            time: timestamp,
            product: pro));
    notifyListeners();
  }
}
