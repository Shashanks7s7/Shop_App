import'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/drawer.dart';
import 'package:shop/widgets/item.dart';
class UserProduct extends StatelessWidget {
  @override
  Future<void>  refresh (BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchdata( true);
  }
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title:Text("Cart"),
        centerTitle:true,
        actions: [
          IconButton(onPressed: (){Navigator.of(context).pushNamed('editScreen');}, icon: Icon(Icons.add))
        ],
      ),
      drawer: Draw(),
      body: FutureBuilder(
              future: refresh(context),
              builder: (context,snapshot)=>
              snapshot.connectionState==ConnectionState.waiting?
              
                 Center(child: CircularProgressIndicator()):
              
              RefreshIndicator(
              onRefresh: ()=> refresh(context),
                child: Consumer<Products>(builder: (context,productdata,_)=>Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
            itemCount: productdata.items.length,
            itemBuilder: (_,index){
              return  Column(
                children: [
                  UserItem(productdata.items[index].id.toString(),productdata.items[index].title, productdata.items[index].imageUrl),
                  Divider(),
                ],
              );
            }),
                 )) )
        
    )
    );
  }
}