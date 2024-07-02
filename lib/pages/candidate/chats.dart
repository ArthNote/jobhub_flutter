// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_chats.dart';
import 'package:tutorial2/firebase/firebase_messages.dart';
import 'package:tutorial2/models/chatModel.dart';
import 'package:tutorial2/pages/chatPage.dart';

import '../first.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class CandidateChats extends StatefulWidget {
  const CandidateChats({super.key});

  @override
  State<CandidateChats> createState() => _CandidateChatsState();
}

class _CandidateChatsState extends State<CandidateChats> {
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            color: dark_blue,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Image.asset("assets/icon.png"),
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout, color: dark_blue),
            splashColor: dark_blue.withOpacity(0.5),
            tooltip: "Logout",
          )
        ],
        leadingWidth: 50,
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key});

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
  }

  void openChat(BuildContext context, String chat_id, String name, String rid) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChatPage(name: name, chat_id: chat_id, receiver_id: rid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: ChatStuff().getChats(uid, "Candidate_id"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      padding: EdgeInsets.only(bottom: 8, top: 10),
                      children: snapshot.data!.docs
                          .map((e) => ChatCard(
                              e.get("Recruiter_name"),
                              e.get("Last_msg"),
                              e.get("Time_sent"),
                              e.get("CUnread_msg"),
                              e.get("id"),
                              e.get("Recruiter_id")))
                          .toList(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return Text("Something went wrong");
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget ChatCard(String cname, String last_msg, String time_sent,
      int runread_msg, String id, String cid) {
    return GestureDetector(
      onTap: () => openChat(context, id, cname, cid),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/sydney.png"),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            width: 20,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                cname,
                style: TextStyle(
                    fontSize: 18,
                    color: dark_blue,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  //add the message delivered icon
                  Text(
                    last_msg,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ]),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SizedBox(
              height: 4,
            ),
            Text(time_sent, style: TextStyle(fontSize: 14, color: dark_blue)),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: dark_blue),
              child: Text(runread_msg.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            )
          ])
        ]),
      ),
    );
  }
}
