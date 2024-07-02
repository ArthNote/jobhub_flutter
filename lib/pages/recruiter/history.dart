// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/pages/recruiter/candidatePage.dart';
import 'package:tutorial2/pages/recruiter/recJobPage.dart';

import '../../firebase/firebase_applications.dart';
import '../../global/toast.dart';
import '../../models/applicationModel.dart';
import '../candidate/jobPage.dart';
import '../first.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class RecruiterHistory extends StatelessWidget {
  const RecruiterHistory({super.key});

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'History',
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
          bottom: TabBar(
            indicatorColor: dark_blue, 
            tabs: [
              Tab(
                icon: Icon(
                  Icons.pending_actions,
                  color: dark_blue,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: dark_blue,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: dark_blue,
                ),
              ),
            ]
          ),
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

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

  Future<List<Application>> getApps(String uid, String status) async {
    final apps = await AppStuff().displayRecApps(uid, status);
    return apps;
  }

  void viewJob(BuildContext context,String jid){
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> recJobPage(job_id: jid)),
    );
  }

  void viewCandidate(BuildContext context,String cid){
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> CandidatePage(user_id: cid)),
    );
  }

  void changeStatus(BuildContext context, String id, String status) async{
    Navigator.pop(context);
    bool r = await AppStuff().updateStatus(id, status);
    if(r == true){
      showToast(message: "Status changed successfully");
      setState(() {});
    }else{
      showToast(message: "Failed to update the status");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Column(
          children: [
            FutureBuilder<List<Application>>(
              future: getApps(uid, "Pending"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Application> apps = snapshot.data!;
                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: ListView.builder(
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            var app = apps[index];
                            final d = DateTime.now().difference(DateTime.parse(app.date));
                            int w = int.parse(d.inDays.toString());
                            String date = "";
                            int month = 31;
                            int year = 365;
                            if (w == 0) {
                              date = "Today";
                            } else if (w == 1) {
                              date = "Yesterday";
                            } else if (w > 1 && w < month) {
                              date = w.toString() + " days ago";
                            } else if (w == month) {
                              date = "1 month ago";
                            } else if (w > month && w < year) {
                              //check if w divided by month equals a whole number
                              if (w % month == 0) {
                                date = (w / month).toString() + " months ago";
                              } else {
                                date = (w / month).floor().toString() + " months ago";
                              }
                            } else if (w == year) {
                              date = "1 year ago";
                            } else if (w > year) {
                              if (w % year == 0) {
                                date = (w / year).toString() + " years ago";
                              } else {
                                date = (w / year).floor().toString() + " years ago";
                              }
                            } else {
                              date = "error";
                            }
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 2,
                                margin: EdgeInsets.only(bottom: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                child: Image.asset(
                                                  "assets/app.png",
                                                  height: 65,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(app.title,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            color: dark_blue,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w500)),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(app.company,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: light_blue,
                                                          fontSize: 15,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: dark_blue,
                                                  ),
                                                  itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: ListTile(
                                                            onTap: () => viewCandidate(context, app.candidate_id),
                                                            leading: Icon(
                                                              Icons.person,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("View Candidate",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: ListTile(
                                                            onTap: () => viewJob(context, app.job_id),
                                                            leading: Icon(
                                                              Icons.work,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("View Job",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 3,
                                                          child: ListTile(
                                                            onTap: () {
                                                              changeStatus(context, app.id, "Accepted");
                                                            },
                                                            leading: Icon(
                                                              Icons.done,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("Accept",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 4,
                                                          child: ListTile(
                                                            onTap: () {
                                                              changeStatus(context, app.id, "Rejected");
                                                            },
                                                            leading: Icon(
                                                              Icons.close,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("Reject",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                      ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                              child: Icon(
                                                Icons.date_range,
                                                color: dark_blue,
                                                size: 27,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                              child: Text("Date Applied:",
                                                  style: TextStyle(
                                                      color: dark_blue,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Text(date,
                                              style: TextStyle(
                                                  color: light_blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ));
                  } else if (snapshot.hasError) {
                    showToast(message: snapshot.error.toString());
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    showToast(message: "Something went wrong");
                    return Center(child: Text("Something went wrong"));
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  showToast(message: "Something went wrong");
                  return Text("Something went wrong");
                }
              },
            ),
          ],
        ),
        Column(
          children: [
            FutureBuilder<List<Application>>(
              future: getApps(uid, "Accepted"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Application> apps = snapshot.data!;
                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: ListView.builder(
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            var app = apps[index];
                            final d = DateTime.now().difference(DateTime.parse(app.date));
                            int w = int.parse(d.inDays.toString());
                            String date = "";
                            int month = 31;
                            int year = 365;
                            if (w == 0) {
                              date = "Today";
                            } else if (w == 1) {
                              date = "Yesterday";
                            } else if (w > 1 && w < month) {
                              date = w.toString() + " days ago";
                            } else if (w == month) {
                              date = "1 month ago";
                            } else if (w > month && w < year) {
                              //check if w divided by month equals a whole number
                              if (w % month == 0) {
                                date = (w / month).toString() + " months ago";
                              } else {
                                date = (w / month).floor().toString() + " months ago";
                              }
                            } else if (w == year) {
                              date = "1 year ago";
                            } else if (w > year) {
                              if (w % year == 0) {
                                date = (w / year).toString() + " years ago";
                              } else {
                                date = (w / year).floor().toString() + " years ago";
                              }
                            } else {
                              date = "error";
                            }
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 2,
                                margin: EdgeInsets.only(bottom: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                child: Image.asset(
                                                  "assets/app.png",
                                                  height: 65,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(app.title,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            color: dark_blue,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w500)),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(app.company,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: light_blue,
                                                          fontSize: 15,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: dark_blue,
                                                  ),
                                                  itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: ListTile(
                                                            onTap: () => viewCandidate(context, app.candidate_id),
                                                            leading: Icon(
                                                              Icons.person,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("View Candidate",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: ListTile(
                                                            onTap: () => viewJob(context, app.job_id),
                                                            leading: Icon(
                                                              Icons.work,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("View Job",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 3,
                                                          child: ListTile(
                                                            onTap: () {
                                                              changeStatus(context, app.id, "Accepted");
                                                            },
                                                            leading: Icon(
                                                              Icons.done,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("Accept",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 4,
                                                          child: ListTile(
                                                            onTap: () {
                                                              changeStatus(context, app.id, "Rejected");
                                                            },
                                                            leading: Icon(
                                                              Icons.close,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("Reject",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                      ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                              child: Icon(
                                                Icons.date_range,
                                                color: dark_blue,
                                                size: 27,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                              child: Text("Date Applied:",
                                                  style: TextStyle(
                                                      color: dark_blue,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Text(date,
                                              style: TextStyle(
                                                  color: light_blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ));
                  } else if (snapshot.hasError) {
                    showToast(message: snapshot.error.toString());
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    showToast(message: "Something went wrong");
                    return Center(child: Text("Something went wrong"));
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  showToast(message: "Something went wrong");
                  return Text("Something went wrong");
                }
              },
            ),
          ],
        ),
        Column(
          children: [
            FutureBuilder<List<Application>>(
              future: getApps(uid, "Rejected"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<Application> apps = snapshot.data!;
                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: ListView.builder(
                          itemCount: apps.length,
                          itemBuilder: (context, index) {
                            var app = apps[index];
                            final d = DateTime.now().difference(DateTime.parse(app.date));
                            int w = int.parse(d.inDays.toString());
                            String date = "";
                            int month = 31;
                            int year = 365;
                            if (w == 0) {
                              date = "Today";
                            } else if (w == 1) {
                              date = "Yesterday";
                            } else if (w > 1 && w < month) {
                              date = w.toString() + " days ago";
                            } else if (w == month) {
                              date = "1 month ago";
                            } else if (w > month && w < year) {
                              //check if w divided by month equals a whole number
                              if (w % month == 0) {
                                date = (w / month).toString() + " months ago";
                              } else {
                                date = (w / month).floor().toString() + " months ago";
                              }
                            } else if (w == year) {
                              date = "1 year ago";
                            } else if (w > year) {
                              if (w % year == 0) {
                                date = (w / year).toString() + " years ago";
                              } else {
                                date = (w / year).floor().toString() + " years ago";
                              }
                            } else {
                              date = "error";
                            }
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 2,
                                margin: EdgeInsets.only(bottom: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                child: Image.asset(
                                                  "assets/app.png",
                                                  height: 65,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(app.title,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            color: dark_blue,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w500)),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(app.company,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: light_blue,
                                                          fontSize: 15,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              PopupMenuButton(
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: dark_blue,
                                                  ),
                                                  itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          value: 1,
                                                          child: ListTile(
                                                            onTap: () => viewCandidate(context, app.candidate_id),
                                                            leading: Icon(
                                                              Icons.person,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("View Candidate",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 2,
                                                          child: ListTile(
                                                            onTap: () => viewJob(context, app.job_id),
                                                            leading: Icon(
                                                              Icons.work,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("View Job",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 3,
                                                          child: ListTile(
                                                            onTap: () {
                                                              changeStatus(context, app.id, "Accepted");
                                                            },
                                                            leading: Icon(
                                                              Icons.done,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("Accept",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          value: 4,
                                                          child: ListTile(
                                                            onTap: () {
                                                              changeStatus(context, app.id, "Rejected");
                                                            },
                                                            leading: Icon(
                                                              Icons.close,
                                                              color: light_blue,
                                                            ),
                                                            title: Text("Reject",
                                                                style: TextStyle(
                                                                    color: dark_blue,
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ),
                                                      ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                              child: Icon(
                                                Icons.date_range,
                                                color: dark_blue,
                                                size: 27,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                              child: Text("Date Applied:",
                                                  style: TextStyle(
                                                      color: dark_blue,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Text(date,
                                              style: TextStyle(
                                                  color: light_blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ));
                  } else if (snapshot.hasError) {
                    showToast(message: snapshot.error.toString());
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    showToast(message: "Something went wrong");
                    return Center(child: Text("Something went wrong"));
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  showToast(message: "Something went wrong");
                  return Text("Something went wrong");
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}