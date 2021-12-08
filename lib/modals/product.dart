import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
class Product with ChangeNotifier {
  final String ? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  
  bool isfavroite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
    this.isfavroite=false});

Future<void> togglefavroite(String _token,String userId) async{
    final oldstatus=isfavroite;
   isfavroite=!isfavroite;

    notifyListeners();
      var url =
        Uri.https('shopapp-d3dcd-default-rtdb.firebaseio.com', '/UserFavroutes/$userId/$id.json',{'auth':'$_token'});
   try{
     final response= await put(url,body: json.encode(
     
    isfavroite,
   ));
   if (response.statusCode>=400) {
       isfavroite=oldstatus; 
     notifyListeners();
   }
   }catch(error){
     isfavroite=oldstatus; 
     notifyListeners();
   }
   
  
}
}