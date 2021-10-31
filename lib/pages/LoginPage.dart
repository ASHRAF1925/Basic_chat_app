
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/models/UIHelper.dart';
import 'package:new_chat_app/models/UserModel.dart';

import 'HomePage.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email == "" || password == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Logging In..");

    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      // Close the loading dialog
      Navigator.pop(context);

      // Show Alert Dialog
      UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

      // Go to HomePage
      print("Log In Successful!");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(userModel: userModel, firebaseUser: credential!.user!);
          }
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
      ),
      body: SafeArea(
        child: Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [
            Colors.redAccent,
        Colors.greenAccent,
        ],),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [

                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.black,
                  child: Container(
                  //width:100,
                  //height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    image: DecorationImage(
                      image: AssetImage("assets/images/wl.gif"),

                    ),
                  ),
                  ),
                ),
                  SizedBox(height: 10,),

                  AnimatedContainer(

                    duration: Duration(milliseconds: 200),
                    height: 100,
                    width: 500,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.yellow,
                          ],
                        ),
                        boxShadow:[
                          BoxShadow(
                            color: Colors.green.withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 16,
                            offset: Offset(-8, 0),
                          ),
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.6),
                            spreadRadius: 1,
                            blurRadius: 16,
                            offset: Offset(8, 0),
                          ),
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            spreadRadius: 16,
                            blurRadius: 32,
                            offset: Offset(-8, 0),
                          ),
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.2),
                            spreadRadius: 16,
                            blurRadius: 32,
                            offset: Offset(8, 0),
                          )
                        ]
                    ),
                    child: Center(
                      child: Text("Chit-Chat", style: TextStyle(
                        color: Colors.red,
                        fontSize: 45,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    style:TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                      fontWeight: FontWeight.bold,
                  ),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    style:TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CupertinoButton(
                      onPressed: () {
                        checkValues();
                      },
                      //color: Theme.of(context).colorScheme.secondary,
                      child: Text("Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.redAccent,
                          Colors.greenAccent,
                        ],),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Don't have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        Container(

                          child: CupertinoButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      return SignUpPage();
                                    }
                                ),
                              );
                            },
                            child: Container(
                              width: 100,

                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text("Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white
                                  ),),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}