import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
class Product_Detail extends StatelessWidget {

 
  @override
  Widget build(BuildContext context) {
    final routearg=ModalRoute.of(context)!.settings.arguments as String ;
    final itemdetail=Provider.of<Products>(context,listen: false).findbyid(routearg);
   
    return Scaffold(
    
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(  
            expandedHeight: 300,
            pinned: true,
           flexibleSpace: FlexibleSpaceBar(  title: Container(
             padding: EdgeInsets.all(8),
             width: double.infinity,
        
             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
             gradient: LinearGradient(colors:[ Colors.lightGreen,Colors.white],begin: Alignment.topLeft,end: Alignment.topRight)),
             child: Text(itemdetail.title.toUpperCase(),
             style: TextStyle(
               fontFamily:'Lato',
               fontWeight: FontWeight.bold
             ),),),
           background: Hero(
              tag: itemdetail.id!,
              child: Image.network(itemdetail.imageUrl,fit: BoxFit.fill,))),
           
         
           ),
      
           
           
          SliverList(delegate: 
          SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 4),
              child: Text("Desription:",
              style: TextStyle(
                 fontFamily:'Anton',
                 fontSize:18,
                 
               )),
            ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 0),
             child: Text(itemdetail.description,
             style:Theme.of(context).textTheme.title, ),
           ),
           SizedBox(height:90),
          Container(
            width: 200,
            padding: EdgeInsets.all(12),
                  alignment: Alignment.bottomRight,    
                  color: Colors.greenAccent,         
             child: Text("Price: Rs.${itemdetail.price.toString()}",
             softWrap: true,
              style: TextStyle(
                 fontFamily:'Anton',
                 fontSize:22,
                 
               )
             ),),
             SizedBox(height:300)
       

          ]),
          
          ),
           ],
           
      ),
      
     
      
    );
  }
}