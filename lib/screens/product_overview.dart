import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

import 'package:shop/providers/products.dart';
import 'package:shop/widgets/21.1%20badge.dart';
import 'package:shop/widgets/drawer.dart';

import 'package:shop/widgets/product_item.dart';

class ProductOverView extends StatefulWidget {
  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var loading=false;
  var run=true;
  @override
  void didChangeDependencies()  {
    // TODO: implement didChangeDependencies
    if (run){  setState(() {
      loading=true;
    });
    Provider.of<Products>(context).fetchdata().then((_){
     setState(() {
        loading=false;
    });});}
    run=false;
    
   
   
    
  
    super.didChangeDependencies();
  }
 
  var fav = false;
 
  @override
  Future<void>  refresh (BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchdata();
  }
  
  Widget build(BuildContext context) {
  
    final productdata = Provider.of<Products>(context);
    final product = fav?productdata.favitems:productdata.items;
    return Scaffold(
        drawer: Draw(),
        appBar: AppBar(
          title: Text(" My Shop"),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (FilterOption value) {
                  setState(() {
                    if (value == FilterOption.favriotes) {
                      fav = true;
                    } else {
                      fav = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                          child: Text("Show Favroites"),
                          value: FilterOption.favriotes),
                      PopupMenuItem(
                          child: Text("Show All"), value: FilterOption.all),
                    ]),
            Consumer<Cart> (builder:(_,cart,_1)=>Badge(child: IconButton(icon: Icon(Icons.shopping_cart),onPressed:(){ Navigator.of(context).pushNamed('cardScreen');},), value: cart.itemcount.toString(), color: Theme.of(context).accentColor)     
              )  ],
        ),
        body: RefreshIndicator(
          onRefresh: ()=>refresh(context),
                  child: loading?Center(child:CircularProgressIndicator()): GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3 / 2, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                  value: product[index], child: ProductItem());
            },
            itemCount: product.length,
          ),
        ));
  }
}

enum FilterOption { favriotes, all }
  