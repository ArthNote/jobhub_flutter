// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorial2/firebase/firebase_chats.dart';
import 'package:tutorial2/firebase/firebase_messages.dart';
import 'package:tutorial2/global/toast.dart';
import 'package:tutorial2/models/messageModel.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class ChatPage extends StatelessWidget {
  String name = "";
  String chat_id = "";
  String receiver_id = "";
  ChatPage(
      {super.key,
      required this.name,
      required this.chat_id,
      required this.receiver_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: Text(
          name,
          style: TextStyle(
            color: dark_blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Body(receiver_id: receiver_id, chat_id: chat_id),
    );
  }
}

class Body extends StatefulWidget {
  String receiver_id = "";
  String chat_id = "";
  Body({super.key, required this.receiver_id, required this.chat_id});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    //ahah();
  }

  void markSeen() async{
    await MessageStuff().markAllAsSeen(uid, widget.chat_id);
  }

  /*void unSeen() async{
    bool r = await ChatStuff().countUnSeen(widget.chat_id, uid);
    if (r) {
      showToast(message: "good");
    }else{
      showToast(message: "bad");
    }
  }*/

  TextEditingController inputController = TextEditingController();
  //send message
  void sendMessage() async {
    if (inputController.text.isNotEmpty) {
      String message = inputController.text.trim();
      DateTime date = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(date);
      final msg = Message("", uid, widget.receiver_id, message, formattedDate,
          false, DateTime.now());
      bool r = await MessageStuff().sendMessage(msg, widget.chat_id);
      if (r) {
        bool h = await ChatStuff().updateChat(widget.chat_id, message,
            formattedDate, Timestamp.fromDate(DateTime.now()));
        if (h) {
          showToast(message: "Updated chat");
          //ahah();

          /*setState(() {
          });*/
        } else {
          showToast(message: "Failed to update chat");
        }
        inputController.clear();
        showToast(message: "Message sent");
      } else {
        inputController.clear();
        showToast(message: "Message not sent");
      }
    }
  }

  //Stream<List<Message>>? messageStream;

 /* void ahah() async{
    showMessages();
    markSeen();
    unSeen();
    setState(() {
      
    });
  }*/

  /*void showMessages() async{
    messageStream = await MessageStuff().displayMessages(widget.chat_id);
    setState(() {

    });
  }*/

  Widget chatMessageTile(String message, bool byMe, String time_sent, bool isRead) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
              child: Column(
                crossAxisAlignment: byMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomRight: byMe ? Radius.circular(0) : Radius.circular(24),
                          bottomLeft: byMe ? Radius.circular(24) : Radius.circular(0),
                          topRight: Radius.circular(24)),
                      color: byMe ? light_blue : dark_blue,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          time_sent,
                          style: TextStyle(
                            color: dark_blue,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.done_all,
                          color: isRead ? light_blue : Colors.grey.shade700,
                          size: 17,
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

 /* Widget chatMessageTile(String message, bool byMe) {
    return Row(
      mainAxisAlignment: byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight: byMe ? Radius.circular(0) : Radius.circular(24),
                    bottomLeft: byMe ? Radius.circular(24) : Radius.circular(0),
                    topRight: Radius.circular(24)),
                color: byMe ? light_blue : dark_blue,
              ),
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ))
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder<List<Message>>(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Message> messages = snapshot.data!;
            return ListView.builder(
                padding: EdgeInsets.only(bottom: 8, top: 10),
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  if(message.sender_id == uid){
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(24),
                                    topRight: Radius.circular(24)),
                                color: light_blue,
                              ),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ))
                      ],
                    );
                  }else{
                    return Row(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        Flexible(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                    bottomLeft: Radius.circular(0),
                                    topRight: Radius.circular(24)),
                                color:dark_blue,
                              ),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ))
                      ],
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: Text("Something went wrong"));
          }
        });
  }
*/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
      Expanded(
        child: StreamBuilder(
          stream: MessageStuff().getMessages(widget.chat_id, uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  padding: EdgeInsets.only(bottom: 8, top: 10),
                  reverse: true,
                  children: snapshot.data!.docs.map((e) => chatMessageTile(e.get("Message"), e.get("Sender_id") == uid, e.get("Time_sent"), e.get("IsSeen"))).toList(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: Text("Something went wrong"));
            }
          }
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Row(children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 100,
              controller: inputController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
                suffixIcon: IconButton(
                  onPressed: () => sendMessage(),
                  icon: Icon(Icons.send_rounded),
                  iconSize: 30,
                  splashColor: light_blue,
                ),
                floatingLabelStyle: TextStyle(
                    color: dark_blue,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: dark_blue, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Type your message",
              ),
            ),
          ),
        ]),
      )
    ]);
  }
}
