import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productid;
 final double price;
  final int quantity;
  final String title;
  
  CartItem(this.id,this.productid,this.price,this.quantity,this.title);
  @override
  Widget build(BuildContext context) {
    final cartd=Provider.of<Cart>(context,listen: false);
    return  Dismissible(
          
          key: ValueKey(id),
          background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction){
            return showDialog(context:context,builder:(context){
                    return AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("Do you want to remove the item from the cart?"),
                      actions: [
                       RaisedButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("No")),
                        RaisedButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text("Yes")),
                      ],
                    );
            });
          },
          onDismissed: (direction){cartd.removeItem(productid);},
          child: Card(
        margin: EdgeInsets.symmetric(horizontal:15,vertical: 5),
          elevation: 5,
          
                                  child: ListTile(
                 title:Text(title),
                 subtitle:Text("Total: Rs.${( price*quantity).toString()}"),
              
                 leading: CircleAvatar(
                   backgroundColor: Theme.of(context).accentColor,
                   radius: 25,
                   child:Padding(
                     padding: const EdgeInsets.all(6.0),
                     child: FittedBox( child: Text((price).toString())),
                   )),
                 trailing:Text("${quantity.toString()} X") ,
             ),
                  
      ),
    );
  }
}