
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/models/ChatRoomModel.dart';
import 'package:new_chat_app/models/FirebaseHelper.dart';
import 'package:new_chat_app/models/UserModel.dart';
import 'ChatRoomPage.dart';
import 'LoginPage.dart';
import 'SearchPage.dart';


class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int currentIndex=0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chit-Chat"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  }
                ),
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active) {
                if(snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                      Map<String, dynamic> participants = chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel.uid);

                      return Container(
                        color: Colors.black,
                        padding: EdgeInsets.all(20),
                        child: FutureBuilder(
                          future: FirebaseHelper.getUserModelById(participantKeys[0]),
                          builder: (context, userData) {
                            if(userData.connectionState == ConnectionState.done) {
                              if(userData.data != null) {
                                UserModel targetUser = userData.data as UserModel;

                                return Container(

                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.lightBlue,
                                        Colors.white,
                                      ],

                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ChatRoomPage(
                                              chatroom: chatRoomModel,
                                              firebaseUser: widget.firebaseUser,
                                              userModel: widget.userModel,
                                              targetUser: targetUser,
                                            );
                                          }),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                                      ),
                                      title: Text(targetUser.fullname.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight:FontWeight.bold,
                                      ),

                                      ),
                                      subtitle: (chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString(),style: TextStyle(
                                        fontSize: 15,
                                        fontWeight:FontWeight.bold,
                                      ),) : Text("Say hi to your new friend!", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight:FontWeight.bold,
                                      ),),
                                    ),
                                  ),
                                );
                              }
                              else {
                                return Container();
                              }
                            }
                            else {
                              return Container();
                            }
                          },
                        ),
                      );
                    },
                  );
                }
                else if(snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                else {
                  return Center(
                    child: Text("No Chats"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: Icon(Icons.search),
      ),
      bottomNavigationBar:BottomNavigationBar(
        selectedFontSize: 20,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        iconSize: 40,
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex=index;
            print(currentIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label:'World chat',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label:'Locy Chat',
            backgroundColor: Colors.greenAccent,
          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.trending_up),
            label:'Trendy Chat',
            backgroundColor: Colors.redAccent,
          ),
        ],
      ) ,
    );
  }
}