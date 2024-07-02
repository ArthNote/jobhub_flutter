// ignore_for_file: prefer_const_constructors, must_be_immutable, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_chats.dart';
import 'package:tutorial2/firebase/firebase_user.dart';
import 'package:tutorial2/global/toast.dart';

import '../../models/chatModel.dart';
import '../../models/userModel.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);
const Color box_color = Color.fromARGB(255, 225, 231, 245);

class CandidatePage extends StatelessWidget {
  String user_id;
  CandidatePage({super.key, required this.user_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: Text(
          'Candidate Details',
          style: TextStyle(
            color: dark_blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Body(user_id: user_id),
    );
  }
}

class Body extends StatefulWidget {
  String user_id = "";
  Body({super.key, required this.user_id});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool customIcon = false;

  Future<UserM> getUser(String id) async {
    final user = await UserStuff().displayUser(id);
    return user;
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    viewProfile();
  }

  Future<void> viewProfile() async {
    try {
      await UserStuff().viewProfile(widget.user_id);
    } catch (error) {
      showToast(message: error.toString());
    }
  }

  //start a chat
  void startChat(String cname) async {
    try {
      bool check = await ChatStuff().checkChat(widget.user_id, uid);
      if (check == true) {
        showToast(message: "Chat already exists");
      } else {
        String rname = await UserStuff().getName(uid);
        final newChat = Chat("", widget.user_id, uid, cname, rname, "", "", 0,0,DateTime.now());
        bool r = await ChatStuff().startChat(newChat);
        if (r == true) {
          showToast(message: "Chat created successfully");
        } else {
          showToast(message: "Chat creation failed");
        }
      }
    } catch (error) {
      showToast(message: error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: getUser(widget.user_id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.hasData) {
                UserM user = snapshot.data as UserM;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: SizedBox(
                          height: 170,
                          width: 170,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: CircleAvatar(
                                radius: 100,
                                child: Image.asset("assets/josef.png"),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(children: [
                          Text(
                            user.fname.substring(0, 1).toUpperCase() +
                                user.fname.substring(1) +
                                " " +
                                user.lname.substring(0, 1).toUpperCase() +
                                user.lname.substring(1),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: dark_blue,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            user.specs + "-" + user.gender,
                            style: TextStyle(color: light_blue, fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            user.email,
                            style: TextStyle(color: light_blue, fontSize: 16),
                          )
                        ]),
                      )),

                      //list tiles
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Column(children: [
                          ExpansionTile(
                            title: Text(
                              "About Me",
                              style: TextStyle(fontSize: 17),
                            ),
                            childrenPadding: EdgeInsets.fromLTRB(17, 0, 17, 15),
                            expandedAlignment: Alignment.centerLeft,
                            backgroundColor: Colors.white,
                            collapsedBackgroundColor: Colors.white,
                            //add a collapsed shape
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            children: [
                              Text(
                                  user.about.substring(0, 1).toUpperCase() +
                                      user.about.substring(1),
                                  style: TextStyle(
                                    color: dark_blue,
                                    fontSize: 15,
                                  ))
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() => customIcon = expanded);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ExpansionTile(
                            title: Text(
                              "Details",
                              style: TextStyle(fontSize: 17),
                            ),
                            childrenPadding: EdgeInsets.fromLTRB(17, 0, 17, 15),
                            expandedAlignment: Alignment.centerLeft,
                            backgroundColor: Colors.white,
                            collapsedBackgroundColor: Colors.white,
                            //add a collapsed shape
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            children: [
                              Row(
                                children: [
                                  Text("Years Of Experience:",
                                      style: TextStyle(
                                          color: dark_blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      user.exp.toString()+" Years",
                                      style: TextStyle(
                                        color: dark_blue,
                                        fontSize: 15,
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Graduation Percentage:",
                                      style: TextStyle(
                                          color: dark_blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      user.grad.toString()+"%",
                                      style: TextStyle(
                                        color: dark_blue,
                                        fontSize: 15,
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Post Graduation Percentage:",
                                      style: TextStyle(
                                          color: dark_blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      user.pgrad.toString()+"%",
                                      style: TextStyle(
                                        color: dark_blue,
                                        fontSize: 15,
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text("Phone Number:",
                                      style: TextStyle(
                                          color: dark_blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      user.phone,
                                      style: TextStyle(
                                        color: dark_blue,
                                        fontSize: 15,
                                      )
                                  ),
                                ],
                              ),
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() => customIcon = expanded);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ExpansionTile(
                            title: Text(
                              "Skills",
                              style: TextStyle(fontSize: 17),
                            ),
                            childrenPadding: EdgeInsets.fromLTRB(17, 0, 17, 15),
                            expandedAlignment: Alignment.centerLeft,
                            backgroundColor: Colors.white,
                            collapsedBackgroundColor: Colors.white,
                            //add a collapsed shape
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            children: [
                              Text(user.skills,
                                  style: TextStyle(
                                    color: dark_blue,
                                    fontSize: 15,
                                  ))
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() => customIcon = expanded);
                            },
                          ),
                        ]),
                      ),
                      
                      //message button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: ElevatedButton(
                          //make the button take more width
                          style: ElevatedButton.styleFrom(
                            //give it border radius of 20
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            
                            backgroundColor: light_blue,
                            minimumSize: Size(355, 57),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          onPressed: () {}, 
                          child: Text("DOWNLOAD PDF"),
                        ),
                      ),

                      //download pdf button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                        child: ElevatedButton(
                          //make the button take more width
                          style: ElevatedButton.styleFrom(
                            //give it border radius of 20
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            
                            backgroundColor: dark_blue,
                            minimumSize: Size(355, 57),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          onPressed: () => startChat(user.fname+" "+user.lname), 
                          child: Text("MESSAGE"),
                        ),
                      ),
                    ]);
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return Center(child: Text("Something went wrong"));
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text("Something went wrong");
            }
          }),
    );
  }
}
