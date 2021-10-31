
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chat_app/models/UIHelper.dart';
import 'package:new_chat_app/models/UserModel.dart';

import 'CompleteProfile.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(email == "" || password == "" || cPassword == "") {
      UIHelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields");
    }
    else if(password != cPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch", "The passwords you entered do not match!");
    }
    else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
      Navigator.pop(context);

      UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: ""
      );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        print("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CompleteProfile(userModel: newUser, firebaseUser: credential!.user!);
            }
          ),
        );
      });
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text("Signup")),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.purpleAccent,
              ],),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
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

                  SizedBox(height: 10,),

                  Container(
                    width: 700,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.blue,
                        ],),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Center(
                        child: TextField(
                          style: TextStyle(color: Colors.white),

                          controller: emailController,
                          decoration: InputDecoration(

                            labelText: "Email Address",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: 700,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.blue,
                        ],),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: 700,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.blue,
                        ],),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: cPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )
                        ),
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

                      child: Text("Sign Up",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.redAccent,
                          Colors.greenAccent,
                        ],),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Already have an account?", style: TextStyle(
                            fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),

                        SizedBox(width: 10,),

                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CupertinoButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Log In", style: TextStyle(
                                fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
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