import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';

class Draw extends StatefulWidget {
  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  var click = false;

  @override
  Widget build(BuildContext context) {
    final authdata = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello Friends"),
          automaticallyImplyLeading: true,
        ),
        SizedBox(height: 15),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text(
            "Home Page",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders", style: Theme.of(context).textTheme.subtitle1),
          onTap: () {
            Navigator.of(context).pushNamed('orderScreen');
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Manage Products",
              style: Theme.of(context).textTheme.subtitle1),
          onTap: () {
            Navigator.of(context).pushNamed('useritemScreen');
          },
        ),
        ListTile(
          leading: !click ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
          title: Text("About Me", style: Theme.of(context).textTheme.subtitle1),
          onTap: () {
            setState(() {
              click = !click;
            });
          },
        ),
        if (click)
          Container(
              height: 150,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        
                          height: 80,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left:2.0),
                            child: Image.asset(
                              'assets/images/hero.jpg',
                              fit: BoxFit.cover,
                            ),
                          )),
                      // ignore: prefer_const_constructors
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            ' My name is Shashank Subedi. I have been learning flutter since 2021. This is my first project as a learner but i still manage to add some extra feature in this application.',style: TextStyle(
fontFamily:'Lato',

                            ),),
                      ))
                    ],
                  )
                ],
              )),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings", style: Theme.of(context).textTheme.subtitle1),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Log Out", style: Theme.of(context).textTheme.subtitle1),
          onTap: () {
            Navigator.of(context).pop;
            Navigator.of(context).pushReplacementNamed('/');
            authdata.logout();
          },
        ),
      ]),
    );
  }
}
