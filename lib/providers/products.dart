import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shop/modals/exception.dart';
import 'package:shop/modals/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String? _token;
  String? userId;

  void update(String token ,String id) {
    _token = token;
    userId=id;
   
  }

  List<Product> get items {
    return [..._items];
  }

  Product findbyid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favitems {
    return _items.where((element) => element.isfavroite).toList();
  }

  Future<void> fetchdata([ bool filter=false]) async {
    var fu= filter?'orderBy="creatorId"&equalTo="$userId"':'';
    var url= Uri.parse(
      'https://shopapp-d3dcd-default-rtdb.firebaseio.com/product.json?auth=$_token&$fu'
    );
   /* var url = Uri.https('shopapp-d3dcd-default-rtdb.firebaseio.com',
        '/product.json',{"auth":'$_token',
        'orderBy':'creatorId',
        'equalTo':'$userId'
        
      
      
        });*/
    try {
      final response = await http.get(url);
      final productfetch = json.decode(response.body) as Map<String, dynamic>;

      if (productfetch == null) {
        return;
      }
        url =
        Uri.https('shopapp-d3dcd-default-rtdb.firebaseio.com', '/UserFavroutes/$userId.json',{'auth':'$_token'});
      final favroiteresponse= await http.get(url);
      final favdata= json.decode(favroiteresponse.body);

      final List<Product> loadedproducts = [];

      productfetch.forEach((index, value) {
        loadedproducts.add(Product(
            id: index.toString(),
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageurl'],
            isfavroite: favdata==null?false:favdata[index]??false ));
      });
      
      _items = loadedproducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    var url =
        Uri.https('shopapp-d3dcd-default-rtdb.firebaseio.com', '/product.json',{'auth':'$_token'});
    try {
      final response = await http.post(url,
          body: json.encode({
            'creatorId': userId,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageurl': product.imageUrl,
           
          }));

      final newproduct = Product(
          id: json.decode(
              response.body)['name'], //json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> replaceProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      var url = Uri.https(
          'shopapp-d3dcd-default-rtdb.firebaseio.com', '/product/$id.json',{'auth':'$_token'});
      http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
          
            'imageurl':newProduct.imageUrl
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> removeitems(String id) async {
    var url = Uri.https(
        'shopapp-d3dcd-default-rtdb.firebaseio.com', '/product/$id.json',{'auth':'$_token'});
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product.');
    }
    existingProduct = null;
  }
 
}
