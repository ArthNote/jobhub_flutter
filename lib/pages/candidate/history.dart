// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_applications.dart';
import 'package:tutorial2/firebase/firebase_bookmarks.dart';
import 'package:tutorial2/global/toast.dart';
import 'package:tutorial2/models/applicationModel.dart';
import 'package:tutorial2/models/bookmarkModel.dart';
import 'package:tutorial2/pages/candidate/jobPage.dart';

import '../first.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class CandidateHistory extends StatefulWidget {
  const CandidateHistory({super.key});

  @override
  State<CandidateHistory> createState() => _CandidateHistoryState();
}

class _CandidateHistoryState extends State<CandidateHistory> {
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'History',
            style: TextStyle(
              color: dark_blue,
            ),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: const Color(0xFFF3F6FD),
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
          bottom: TabBar(indicatorColor: dark_blue, tabs: [
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
              //add a X icon
              icon: Icon(
                Icons.cancel_outlined,
                color: dark_blue,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.bookmark_added_outlined,
                color: dark_blue,
              ),
            ),
          ]),
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
    final apps = await AppStuff().displayUserApps(uid, status);
    return apps;
  }

  Future<List<BookMark>> getBs() async {
    final saves = await BookmarkStuff().displayBookmarks(uid);
    return saves;
  }

  void viewJob(BuildContext context,String jid){
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> JobPage(job_id: jid)),
    );
  }

  void removeB(String id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Remove Bookmark?", style: TextStyle(color: dark_blue),),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("This job is already bookmarked.", style: TextStyle(color: dark_blue),),
                SizedBox(height: 10,),
                Text("Are you sure you want to remove it?", style: TextStyle(color: dark_blue),),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  removeBookmark(id);
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
  }

  void removeBookmark(String id) async {
    bool result = await BookmarkStuff().removeBo(id);
    if (result) {
      showToast(message: "Bookmark removed successfully");
      setState(() {});
    } else {
      showToast(message: "Something went wrong while removing bookmark");
    }
  }

  void deleteApp(String id) async {
    bool r = await AppStuff().removeApplication(id);
    if (r == true) {
      showToast(message: "Application removed successfully");
      setState(() {});
    } else {
      showToast(message: "Application deletion failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
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
                          onTap: () {} /*=> goTo(context, job.id)*/,
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
                                                        onTap: () => viewJob(context,app.job_id),
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
                                                      value: 2,
                                                      child: ListTile(
                                                        onTap: () {
                                                          deleteApp(app.id);
                                                          Navigator.pop(context);
                                                        }
                                                        ,
                                                        leading: Icon(
                                                          Icons.delete,
                                                          color: light_blue,
                                                        ),
                                                        title: Text("Un-Apply",
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
                          onTap: () {} /*=> goTo(context, job.id)*/,
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
                                                        onTap: () => viewJob(context,app.job_id),
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
                                                      value: 2,
                                                      child: ListTile(
                                                        onTap: () {
                                                          deleteApp(app.id);
                                                          Navigator.pop(context);
                                                        }
                                                        ,
                                                        leading: Icon(
                                                          Icons.delete,
                                                          color: light_blue,
                                                        ),
                                                        title: Text("Un-Apply",
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
                          onTap: () {} /*=> goTo(context, job.id)*/,
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
                                                        onTap: () => viewJob(context,app.job_id),
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
                                                      value: 2,
                                                      child: ListTile(
                                                        onTap: () {
                                                          deleteApp(app.id);
                                                          Navigator.pop(context);
                                                        }
                                                        ,
                                                        leading: Icon(
                                                          Icons.delete,
                                                          color: light_blue,
                                                        ),
                                                        title: Text("Un-Apply",
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
        FutureBuilder<List<BookMark>>(
          future: getBs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<BookMark> books = snapshot.data!;
                return Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        var book = books[index];
                        return GestureDetector(
                          onTap: () => viewJob(context, book.jid),
                          child: Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Image.asset("assets/company.png"),
                                        ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(bottom: 6),
                                                child: Text(book.title,
                                                    style: TextStyle(
                                                        color: dark_blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16)),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 2),
                                                  child: Text(
                                                      book.company + " - " + book.location,
                                                      style: TextStyle(
                                                          color: dark_blue, fontSize: 14)))
                                            ]),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                        child: IconButton(
                                          icon: Icon(Icons.bookmark, color: light_blue),
                                          onPressed: () => removeB(book.id),
                                        )
                                    )
                                  ],
                                ),
                                Row(children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color.fromARGB(255, 243, 246, 253)),
                                      child: Text(book.time,
                                          style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color.fromARGB(255, 243, 246, 253)),
                                      child: Text(
                                          book.min_exp.toString() +
                                              "-" +
                                              book.max_exp.toString() +
                                              " years",
                                          style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color.fromARGB(255, 243, 246, 253)),
                                      child: Text(book.type,
                                          style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                ]),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Image.asset("assets/applicants.png", height: 22),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Text("21 Applications",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: Text(book.date,
                                        style: TextStyle(
                                            color: dark_blue,
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
    ]);
  }
}
