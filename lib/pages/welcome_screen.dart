
import 'dart:async';

import 'package:flutter/material.dart';

import 'LoginPage.dart';

class welcome_screen extends StatefulWidget {
  const welcome_screen({Key? key}) : super(key: key);

  @override
  _welcome_screenState createState() => _welcome_screenState();
}

class _welcome_screenState extends State<welcome_screen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>LoginPage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wl.gif"),

            ),
          ),
          child: Column(
            children: [
              SizedBox(height:600,),
              Center(
                child: Text(
                  "Chit-Chat",
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontFamily: "Satisfy",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text("Chat With a Different Taste!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
