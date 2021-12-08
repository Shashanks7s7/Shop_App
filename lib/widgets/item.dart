import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
class UserItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  UserItem(this.id,this.title,this.image);
  @override
  Widget build(BuildContext context) {
    final scaffold =Scaffold.of(context);
    return 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(title),
          leading: CircleAvatar(backgroundImage:NetworkImage(image)),
          trailing: Container(
            width:100,
            child: Row(
              children: [
                IconButton(onPressed: (){Navigator.of(context).pushNamed('editScreen',arguments: id);}, icon: Icon(Icons.edit),color: Theme.of(context).primaryColor,),
                 IconButton(onPressed: () async{
                   try{
                 await  Provider.of<Products>(context,listen:false).removeitems(id);
                   }catch(error){
                     scaffold.showSnackBar(SnackBar(content: Text('Deleting Failed',textAlign: TextAlign.center)));
                   }
                   },icon: Icon(Icons.delete),color: Theme.of(context).errorColor,)
              ],
            ),
          ),


        
    ),
      );
  }
}