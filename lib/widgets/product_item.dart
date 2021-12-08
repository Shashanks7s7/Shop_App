import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/modals/product.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';


class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Product>(context, listen: false);
    final cartitem = Provider.of<Cart>(context, listen: false);
    final auth=Provider.of<Auth>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
       child:GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed('productdetails', arguments: items.id),
        
            child: Hero(
              tag: items.id!,
                          child: FadeInImage(
                placeholder:AssetImage('assets/images/hero.jpg') ,
                image: NetworkImage(items.imageUrl),
                
                            
                  fit: BoxFit.cover,
                ),
            ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(
                items.title,
                textAlign: TextAlign.center,
              ),
              leading: Consumer<Product>(
                builder: (context, items, _) => IconButton(
                  onPressed: () {
                    items.togglefavroite(auth.token.toString(),auth.userId.toString());
                  },
                  icon: Icon(
                    items.isfavroite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              trailing: IconButton(
                  onPressed: () {
                    cartitem.additems(items.id.toString(), items.price, items.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Added item to the cart",
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(label: "UNDO",
                      onPressed: (){cartitem.removesingleitem(items.id.toString());}),
                    ));
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).accentColor,
                  )),
            ),
          ),
        ),
      
    );
  }
}
