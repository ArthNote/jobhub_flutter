// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/pages/first.dart';
import 'package:tutorial2/pages/recruiter/addJob.dart';
import 'package:tutorial2/pages/recruiter/updateJob.dart';

import '../../firebase/firebase_jobs.dart';
import '../../global/toast.dart';
import '../../models/jobModel.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class RecruiterDashboard extends StatelessWidget {
  final PageController pageController;
  RecruiterDashboard({super.key, required this.pageController});

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  void addJob(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddJob()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addJob(context),
        child: Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: dark_blue,
      ),
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
      body: Body(pageController: pageController),
    );
  }
}

class Body extends StatefulWidget {
  final PageController pageController;
  Body({super.key, required this.pageController});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";

  void deleteJ(String uid, String jid) async {
    bool r = await JobStuff().deleteJob(uid, jid);
    if (r == true) {
      showToast(message: "Job deleted successfully");
      setState(() {});
    } else {
      showToast(message: "Job deletion failed");
    }
  }

  void editJob(BuildContext context, String id) {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UpdateJob(jid: id)));
  }

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
  }

  Future<List<Job>> getJobs(String id) async {
    final jobs = await JobStuff().displayJobs(id);
    return jobs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Job>>(
            future: getJobs(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<Job> foundJobs = snapshot.data!;
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: ListView.builder(
                        itemCount: foundJobs.length,
                        itemBuilder: (context, index) {
                          var job = foundJobs[index];
                          final d = DateTime.now()
                              .difference(DateTime.parse(job.pub_date));
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
                              date = (w / month).floor().toString() +
                                  " months ago";
                            }
                          } else if (w == year) {
                            date = "1 year ago";
                          } else if (w > year) {
                            if (w % year == 0) {
                              date = (w / year).toString() + " years ago";
                            } else {
                              date =
                                  (w / year).floor().toString() + " years ago";
                            }
                          } else {
                            date = "error";
                          }
                          return Card(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Image.asset(
                                                "assets/company.png"),
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 6),
                                                  child: Text(job.title,
                                                      style: TextStyle(
                                                          color: dark_blue,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16)),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                    child: Text(
                                                        job.company +
                                                            " - " +
                                                            job.location,
                                                        style: TextStyle(
                                                            color: dark_blue,
                                                            fontSize: 14)))
                                              ]),
                                        ],
                                      ),
                                      PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: dark_blue,
                                          ),
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: ListTile(
                                                    onTap: () => editJob(
                                                        context, job.id),
                                                    leading: Icon(
                                                      Icons.edit,
                                                      color: light_blue,
                                                    ),
                                                    title: Text("Edit",
                                                        style: TextStyle(
                                                            color: dark_blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: ListTile(
                                                    onTap: () {
                                                      deleteJ(uid, job.id);
                                                      Navigator.pop(context);
                                                    },
                                                    leading: Icon(
                                                      Icons.delete,
                                                      color: light_blue,
                                                    ),
                                                    title: Text("Delete",
                                                        style: TextStyle(
                                                            color: dark_blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                              ])
                                    ],
                                  ),
                                  Row(children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(9, 6, 9, 6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color.fromARGB(
                                                255, 243, 246, 253)),
                                        child: Text(job.time,
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(9, 6, 9, 6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color.fromARGB(
                                                255, 243, 246, 253)),
                                        child: Text(
                                            job.min_exp.toString() +
                                                "-" +
                                                job.max_exp.toString() +
                                                " years",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(9, 6, 9, 6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color.fromARGB(
                                                255, 243, 246, 253)),
                                        child: Text(job.type,
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                  ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: Image.asset(
                                                  "assets/applicants.png",
                                                  height: 22),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: Text("21 Applications",
                                                  style: TextStyle(
                                                      color: dark_blue,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Text(date,
                                              style: TextStyle(
                                                  color: dark_blue,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400)),
                                        )
                                      ])
                                ],
                              ),
                            ),
                          );
                        }),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: Text("Something went wrong"));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })

        /*Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ListView.builder(
              itemCount: foundJobs.length,
              itemBuilder: (context, index) {
                var job = foundJobs[index];
                return Card(
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
                                      padding: EdgeInsets.only(bottom:6),
                                      child: Text(
                                        job.title,
                                        style: TextStyle(
                                          color: dark_blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        job.company + " - " + job.location,
                                        style: TextStyle(
                                          color: dark_blue,
                                          fontSize: 14
                                        )
                                      )
                                    )
                                  ]
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => save(job.save),
                              tooltip: "Save",
                              splashColor: light_blue.withOpacity(0.5),
                              icon:Icon(
                                job.saved? Icons.bookmark : Icons.bookmark_border,
                                color: job.saved ? light_blue : dark_blue,
                              ), 
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 243, 246, 253)
                                ),
                                child: Text(
                                  job.time,
                                  style: TextStyle(
                                    color: dark_blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 243, 246, 253)
                                ),
                                child: Text(
                                  job.min_exp.toString() + "-" + job.max_exp.toString() + " years",
                                  style: TextStyle(
                                    color: dark_blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 243, 246, 253)
                                ),
                                child: Text(
                                  job.type,
                                  style: TextStyle(
                                    color: dark_blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400
                                  )
                                ),
                              ),
                            ),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Image.asset("assets/applicants.png", height: 22),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    job.apps.toString() + " Applications",
                                    style: TextStyle(
                                      color: dark_blue, 
                                      fontSize: 13, 
                                      fontWeight: FontWeight.w400
                                    )
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                job.date,
                                style: TextStyle(
                                  color: dark_blue, 
                                  fontSize: 13, 
                                  fontWeight: FontWeight.w400
                                )
                              ),
                            )
                          ]
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          )
        )
      */
      ],
    );
  }
}
