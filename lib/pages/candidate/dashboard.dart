// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_chats.dart';
import 'package:tutorial2/firebase/firebase_jobs.dart';
import 'package:tutorial2/firebase/firebase_messages.dart';
import 'package:tutorial2/firebase/firebase_user.dart';
import 'package:tutorial2/pages/first.dart';
import 'package:tutorial2/pages/login.dart';

import '../../firebase/firebase_applications.dart';
import '../../global/toast.dart';
import '../navigation/candidateNav.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class CandidateDashboard extends StatefulWidget {
  final PageController pageController;
  const CandidateDashboard({super.key, required this.pageController});

  @override
  State<CandidateDashboard> createState() => _CandidateDashboardState();
}

class _CandidateDashboardState extends State<CandidateDashboard> {
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
          'Dashboard',
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
      body: Body(pageController: widget.pageController),
    );
  }
}

class Body extends StatefulWidget {
  final PageController pageController;

  const Body({super.key, required this.pageController});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {


  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  int apps = 0;
  int views = 0;
  int msgs = 0;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
      countApplications();
      getViews();
      getMsgs();
    }
  }

  Future<void> countApplications() async {
    try {
      final count = await AppStuff().countApps(uid);
      setState(() {
        apps = count;
      });
    } catch (error) {
      showToast(message: error.toString());
    }
  }
  
  Future<void> getViews() async {
    try {
      final count = await UserStuff().getViews(uid);
      setState(() {
        views = count;
      });
    } catch (error) {
      showToast(message: error.toString());
    }
  }

  Future<void> getMsgs() async {
    try {
      final count = await ChatStuff().sumCUnread(uid);
      setState(() {
        msgs = count;
      });
    } catch (error) {
      showToast(message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        //welcome text
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Row(
            children: [
              Text(
                'Welcome,',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, color: dark_blue),
              ),
            ],
          ),
        ),

        //name text
        Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
          child: Row(
            children: [
              Text(
                'Yassine Moussaid',
                style: TextStyle(
                    fontSize: 25,
                    color: dark_blue,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        //big box
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: dark_blue),
          child: Column(children: <Widget>[
            //main text
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Find And Land Your Next Job',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),

            //smaller text
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Daily job postings at your fingertips - never miss out on your next career move.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),

            //button
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(320, 52),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {widget.pageController.jumpToPage(1);}, 
                child: Text(
                  "SEARCH FOR A JOB",
                  style: TextStyle(color: dark_blue),
                ),
              ),
            )
          ]),
        ),

        //activity text
        Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
          child: Row(
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                    fontSize: 25,
                    color: dark_blue,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        //three boxes

        Padding(
            padding: EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                          child: CircleAvatar(
                              radius: 30,
                              //backgroundImage: AssetImage("assets/mail.png"),
                              backgroundColor:
                                  Color.fromARGB(255, 203, 227, 255),
                              child: Image.asset("assets/mail.png")),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 10),
                            child: Text(
                              msgs.toString()+' new messages',
                              style: TextStyle(
                                  color: dark_blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 0, bottom: 10),
                            child: Text(
                              'Check your Inbox!',
                              style: TextStyle(
                                color: dark_blue,
                                fontSize: 15,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Column(children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CircleAvatar(
                                radius: 30,
                                //backgroundImage: AssetImage("assets/mail.png"),
                                backgroundColor:
                                    Color.fromARGB(255, 248, 203, 255),
                                child: Image.asset("assets/form.png")),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  apps.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: dark_blue),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Applications'),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: CircleAvatar(
                                radius: 30,
                                //backgroundImage: AssetImage("assets/mail.png"),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 234, 203),
                                child: Image.asset("assets/eye.png")),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      views.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: dark_blue),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Profile Views',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ])
                ]))
      ]),
    );
  }
}
