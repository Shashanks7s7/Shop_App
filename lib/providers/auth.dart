import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/modals/exception.dart';

class Auth with ChangeNotifier {
  String? userId;
  DateTime? _expirytime;
  String? _token;
  Timer? authTimer;
  bool get authd {
    return token != null;
  }

  String? get token {
    if (_expirytime != null &&
        _expirytime!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }
  String? get userid{
    return userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyApiUVOTxrTKuvfwKKCQu0EP2dZj7n8ZvA');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      

      final responsedata = json.decode(response.body);
      if (responsedata['error'] != null) {
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      userId = responsedata['localId'];
      //print(json.decode(responsedata));
      _expirytime = DateTime.now()
          .add(Duration(seconds: int.parse(responsedata['expiresIn'])));
          autologout();

      notifyListeners();
      final prefs= await SharedPreferences.getInstance();
      final userdata= json.encode({
        'token':_token,
        'userid':userId,
        'expirydata':_expirytime!.toIso8601String()
      });
      prefs.setString('userdata', userdata);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password,'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }
  Future<bool?> tryautologin ()async{
    final prefs= await SharedPreferences.getInstance();
    if(!prefs.containsKey('userdata')){
  return false;
    }
    final extracteddata=json.decode(prefs.getString("userdata").toString()) as Map<String,Object> ;
    final expire=DateTime.parse(extracteddata['expirydata'].toString());
    if(expire.isBefore(DateTime.now())){
      return false;
    }
    _token=extracteddata['token'].toString();
    userId=extracteddata['userid'].toString();
    _expirytime=expire;
    notifyListeners();
    autologout();
    return true;

  }
Future<void> logout() async{
  _token=null;
  userId=null;
  _expirytime=null;
  if(authTimer!=null){
    authTimer!.cancel();
    authTimer=null;
  }
  notifyListeners();
  final prefs= await SharedPreferences.getInstance();
  prefs.clear();
}
void autologout(){
  if(authTimer!=null){
    authTimer!.cancel();
  }
  final timetoExpiry= _expirytime!.difference(DateTime.now()).inSeconds;
  authTimer= Timer(Duration(seconds: timetoExpiry), logout);
}
}
