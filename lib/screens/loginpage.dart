import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/modals/exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          // height:deviceheight,
          // width:double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.purple],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight)),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceheight.height,
            width: deviceheight.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                  child: Text(
                    "MyShop",
                    style: TextStyle(
                        fontSize: 53,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal),
                  ),
                ),
                transform: Matrix4.rotationZ(-8 * pi / 100),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                  flex: deviceheight.width > 600 ? 2 : 1, child: AuthCard())
            ]),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> key = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> authData = {'email': '', 'password': ''};
  final _passwordcontroller = TextEditingController();
  var isloading = false;
   AnimationController? _controller;
 Animation<Offset>? _heightanimation;
   @override
  void initState() {
      super.initState();
    _controller=AnimationController(vsync:this,duration:Duration(milliseconds: 300));
    _heightanimation = Tween<Offset>(begin:Offset(0,-1),end: Offset(0,0)).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn));
  
  }
 

  void showdialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("An Error Occured."),
            content: Text(message),
            actions: [
              RaisedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Okay"),
              )
            ],
          );
        });
  }

  Future<void> onsaved() async {
    if (!key.currentState!.validate()) {
      return;
    }
    key.currentState!.save();
    setState(() {
      isloading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
            authData['email'].toString(), authData['password'].toString());
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
            authData['email'].toString(), authData['password'].toString());
         
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email is already in use.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find an user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      showdialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you.Please try  again  later';
      showdialog(errorMessage);
    }
    setState(() {
      isloading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final devicesize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 11,
      child: AnimatedContainer(
        duration: Duration(milliseconds:200),
        curve: Curves.fastOutSlowIn,
              child: Container(
        //  height: _heightanimation!.value.height,
        height:_authMode  == AuthMode.Signup?320:260,
          constraints:
              BoxConstraints(
                minHeight: _authMode  == AuthMode.Signup?320:260),
                //minHeight: _heightanimation!.value.height),
          width: devicesize.width * 0.75,
          padding: EdgeInsets.all(15),
         
                      child: Form(
                key: key,
                child: SingleChildScrollView(
                    child: Column(children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Enter Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Invalid Email Address';
                      }
                    },
                    onSaved: (value) {
                      authData['email'] = value.toString();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    controller: _passwordcontroller,
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Password is too short';
                      }
                    },
                    onSaved: (value) {
                      authData['password'] = value.toString();
                    },
                  ),
               
                    AnimatedContainer(
                      duration: Duration(milliseconds:300),
                      curve: Curves.easeIn,
                      constraints: BoxConstraints(minHeight: _authMode==AuthMode.Signup?60:0,maxHeight: _authMode==AuthMode.Signup?120:0),
                                          child: SlideTransition(
                        position: _heightanimation!,
                                            child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(labelText: 'Confirm Passord'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordcontroller.text) {
                                    return 'Password didnot match';
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (isloading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                        onPressed: onsaved,
                        child: Text(
                          _authMode == AuthMode.Login ? "Log In" : 'Sign Up',
                          style: TextStyle(
                              fontFamily: 'Lato', fontWeight: FontWeight.w700),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.orange,
                        padding: EdgeInsets.all(8),
                        textColor: Colors.black87),
                  FlatButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      _authMode == AuthMode.Login ? 'SignUp Instead!' : 'LogIn Instead!',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.orange,
                          fontWeight: FontWeight.w700),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                ]))),
          ),
        ),
      
    );
  }
}
