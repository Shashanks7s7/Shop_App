import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalamount {
    double sum = 0.0;
    _items.forEach((key, artItem) {
      sum +=  artItem.price * artItem.quantity;
    });
    return sum;
    
  }

  int get itemcount {
    return  _items.length;
  }

  void additems(String ProductId, double price,  String title) {
    if (_items.containsKey(ProductId)) {
      _items.update(
          ProductId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
             
              price: value.price
              , quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          ProductId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }
  void removesingleitem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId]!.quantity >1){
 _items.update(productId, (value) => CartItem(id: value.id, title: value.title, quantity: value.quantity-1, price: value.price));
  }
  else{
    _items.remove(productId);
  
  }
  notifyListeners();
  }
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
   void clear(){
    _items={};
notifyListeners(); 
  }
}
