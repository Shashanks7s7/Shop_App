
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop/modals/product.dart';
import 'package:shop/providers/products.dart';

class EditCart extends StatefulWidget {
  @override
  _EditCartState createState() => _EditCartState();
}

class _EditCartState extends State<EditCart> {
  final _pricefocusmode = FocusNode();
  final description = FocusNode();
  final imagecontroller = TextEditingController();
  final imageurlfocus = FocusNode();
  final form = GlobalKey<FormState>();
  var _init = true;
 var _isCircle = false;
  var editedproduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var initvalues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  
  @override
  void initState() {
    imageurlfocus.addListener(updateimageurl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productid = ModalRoute.of(context)!.settings.arguments as String?;

      if (productid != null) {
        editedproduct =
            Provider.of<Products>(context, listen: false).findbyid(productid);

        initvalues = {
          'title': editedproduct.title,
          'description': editedproduct.description,
          'price': editedproduct.price.toString(),
          'imageUrl': ''
        };
        imagecontroller.text = editedproduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageurlfocus.removeListener(updateimageurl);
    _pricefocusmode.dispose();
    description.dispose();
    imagecontroller.dispose();
    imageurlfocus.dispose();

    super.dispose();
  }

  void updateimageurl() {
    if (!imageurlfocus.hasFocus) {
      return;
    }
    setState(() {});
  }

  Future<void> saveform()  async{
    

    final formvalidator = form.currentState!.validate();
    if (!formvalidator) {
      return;
    }
     form.currentState!.save();
    setState(() {
      _isCircle = true;
    });
   
    if (editedproduct.id != null) {
     await Provider.of<Products>(context, listen: false)
          .replaceProduct(editedproduct.id.toString(), editedproduct);
      setState(() {
        _isCircle = false;
      });
      Navigator.of(context).pop();
    } else  {
   try{  await Provider.of<Products>(context, listen: false)
          .addProduct(editedproduct);} catch (error){
         await showDialog <Null> (
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("An Error Occuried!"),
                  content: Text("Something went wrong."),
                  actions: [
                    RaisedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Okay"))
                  ],
                ));} finally{
          setState(() {
            _isCircle = false;
              
          });
          Navigator.of(context).pop();}
       
                
    }
  }
@override
File? image;
Future getimage()async{
  final img= await ImagePicker().getImage(source: ImageSource.gallery);
}
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit"),
          centerTitle: true,
          actions: [IconButton(onPressed: saveform, icon: Icon(Icons.save))],
        ),
        body: _isCircle
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: form,
                    child: ListView(children: [
                      TextFormField(
                        initialValue: initvalues['title'],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefocusmode);
                        },
                        onSaved: (value) {
                          editedproduct = Product(
                              id: editedproduct.id,
                              title: value.toString(),
                              description: editedproduct.description,
                              price: editedproduct.price,
                              imageUrl: editedproduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provite the title.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initvalues['price'],
                        decoration: InputDecoration(hintText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocusmode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(description);
                        },
                        onSaved: (value) {
                          editedproduct = Product(
                              id: editedproduct.id,
                              title: editedproduct.title,
                              description: editedproduct.description,
                              price: double.parse(value.toString()),
                              imageUrl: editedproduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provite the Price.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: initvalues['description'],
                        decoration: InputDecoration(hintText: "Description"),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: description,
                        onSaved: (value) {
                          editedproduct = Product(
                              id: editedproduct.id,
                              title: editedproduct.title,
                              description: value.toString(),
                              price: editedproduct.price,
                              imageUrl: editedproduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provite the description.';
                          }
                          if (value.length < 10) {
                            return 'should be atleast 10 characters long.';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              )),

                              // ignore: prefer_const_constructors
                              child: imagecontroller.text.isEmpty
                                  ? Center(child: Text("Enter a UrL"))
                                  : FittedBox(
                                      child: Image.network(imagecontroller.text,
                                          fit: BoxFit.cover)),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: "Url"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: imagecontroller,
                                onSaved: (value) {
                                  editedproduct = Product(
                                      id: editedproduct.id,
                                      title: editedproduct.title,
                                      description: editedproduct.description,
                                      price: editedproduct.price,
                                      imageUrl: value.toString());
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide the imageurl.';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please provide valid Url.';
                                  }
                                  //    if(!value.endsWith('.jpeg')&& !value.endsWith('.png')&&!value.endsWith('.jpg')){
                                  //    return 'Please provide valid Image Url.';
                                  //}
                                  else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ])
                    ])),
              ));
  }
}
