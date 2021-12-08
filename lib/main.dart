import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/screens/cartscreen.dart';
import 'package:shop/screens/edit_items.dart';
import 'package:shop/screens/loginpage.dart';
import 'package:shop/screens/order_screen.dart';

import 'package:shop/screens/product_detail.dart';
import 'package:shop/screens/product_overview.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(),
            
            update: (_, auth, previousProducts) => previousProducts!
              ..update(
                auth.token.toString(),auth.userId.toString()
              ),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth,Order>(
            create: (context) => Order(),
            update: (_,aut,dat)=>dat!..orderlis(
              aut.token.toString(),
              aut.userId.toString()
            ),
          ),
        
        ],
        child: Consumer<Auth>(builder: (context, aut, _) {
          return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.green,
                accentColor: Colors.blue,
                fontFamily: 'Lato',
              
              ),
              home: aut.authd ? ProductOverView() :FutureBuilder(future:aut.tryautologin(),
              builder: (context,snapshot)=> snapshot.connectionState==ConnectionState.waiting? SplashScreen():AuthScreen()
              ),
              routes: {
                'productdetails': (context) => Product_Detail(),
                'cardScreen': (context) => CartScreen(),
                'orderScreen': (context) => OrderScreen(),
                'useritemScreen': (context) => UserProduct(),
                'editScreen': (context) => EditCart(),
                'auth':(context)=> AuthScreen()
              });
        }));
  }
}
