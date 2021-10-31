import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/main.dart';
import 'package:new_chat_app/models/ChatRoomModel.dart';
import 'package:new_chat_app/models/MessageModel.dart';
import 'package:new_chat_app/models/UserModel.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({Key? key, required this.targetUser, required this.chatroom, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false
      );

      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }
  Color clr1=Colors.blueAccent;
  Color clr2=Colors.orangeAccent;
  //Color clr4=Colors.blueAccent;
  //Color clr3=Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(widget.targetUser.profilepic.toString()),
            ),

            SizedBox(width: 10,),

            Text(widget.targetUser.fullname.toString()),

          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/LBXB.gif"),
            fit: BoxFit.fill,
            ),

          ),
          child: Column(
            children: [

              // This is where the chats will go
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").orderBy("createdon", descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.active) {
                        if(snapshot.hasData) {
                          QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMessage.sender == widget.userModel.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  AnimatedContainer(

                                      duration: Duration(milliseconds: 200),


                                    margin: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(40),
                                          gradient: LinearGradient(
                                            colors:(currentMessage.sender == widget.userModel.uid) ? [
                                              clr1,
                                              clr2,
                                            ] : [clr1=Colors.orangeAccent,
                                              clr2=Colors.blueAccent],
                                          ),
                                          boxShadow:[
                                            BoxShadow(
                                              color: clr1.withOpacity(0.6),
                                              spreadRadius: 1,
                                              blurRadius: 16,
                                              offset: Offset(-8, 0),
                                            ),
                                            BoxShadow(
                                              color:clr2.withOpacity(0.6),
                                              spreadRadius: 1,
                                              blurRadius: 16,
                                              offset: Offset(8, 0),
                                            ),
                                            BoxShadow(
                                              color: clr1.withOpacity(0.2),
                                              spreadRadius: 16,
                                              blurRadius: 32,
                                              offset: Offset(-8, 0),
                                            ),
                                            BoxShadow(
                                              color: clr2.withOpacity(0.2),
                                              spreadRadius: 16,
                                              blurRadius: 32,
                                              offset: Offset(8, 0),
                                            )
                                          ]
                                      ),
                                    /*decoration: BoxDecoration(
                                      color: (currentMessage.sender == widget.userModel.uid) ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),*/
                                    child: Text(
                                      currentMessage.text.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else if(snapshot.hasError) {
                          return Center(
                            child: Text("An error occured! Please check your internet connection."),
                          );
                        }
                        else {
                          return Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      }
                      else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),

              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5
                ),
                child: Row(
                  children: [

                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter message"
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary,),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}