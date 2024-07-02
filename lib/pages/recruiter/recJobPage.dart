// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings, non_constant_identifier_names, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../firebase/firebase_applications.dart';
import '../../firebase/firebase_jobs.dart';
import '../../global/toast.dart';
import '../../models/applicationModel.dart';
import '../../models/jobModel.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);
const Color box_color = Color.fromARGB(255, 225, 231, 245);

class recJobPage extends StatelessWidget {
  String job_id;
  recJobPage({super.key, required this.job_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: Text(
          'Job Details',
          style: TextStyle(
            color: dark_blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Body(
        job_id: job_id,
      ),
    );
  }
}

class Body extends StatefulWidget {
  String job_id = "";
  Body({super.key, required this.job_id});
  
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool customIcon = false;

  Future<Job> getJob(String id) async {
    final job = await JobStuff().displayJob(id);
    return job;
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: getJob(widget.job_id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.hasData) {
                Job job = snapshot.data as Job;
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //basic info
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //title text
                                  Text(
                                    job.title.substring(0, 1).toUpperCase() + job.title.substring(1),
                                      style: TextStyle(
                                          color: dark_blue,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
      
                                  //company + location
                                  Text(job.company.substring(0, 1).toUpperCase() + job.company.substring(1),
                                      style: TextStyle(
                                          color: light_blue, fontSize: 16)),
                                  SizedBox(
                                    height: 10,
                                  ),
      
                                  //details
                                  Row(children: [
                                    Box(
                                      title: job.time.substring(0, 1).toUpperCase() + job.time.substring(1),
                                    ),
                                    Box(
                                      title: job.location.substring(0, 1).toUpperCase() + job.location.substring(1),
                                    ),
                                    Box(
                                      title: job.type.substring(0, 1).toUpperCase() + job.type.substring(1),
                                    )
                                  ]),
                                  Row(children: [
                                    Box(
                                      title: "\$" +job.min_pay.toString()+ "-\$" +job.max_pay.toString()+"k",
                                    ),
                                    Box(
                                      title: job.min_exp.toString()+"-"+job.max_exp.toString()+" yrs",
                                    ),
                                  ]),
                                ]),
                          ],
                        ),
                      ),
      
                      //list tiles collapse-able
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                        child: Column(children: [
                          ExpansionTile(
                            title: Text(
                              "Job Details",
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
                              Text(job.description.substring(0, 1).toUpperCase() + job.description.substring(1),
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
                              "Responsibilities",
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
                              Text(job.resp.substring(0, 1).toUpperCase() + job.resp.substring(1),
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
                              "Full Requirements",
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
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Specialization:",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(job.title.substring(0, 1).toUpperCase() + job.title.substring(1),
                                            style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text("Graduation %:",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(job.grad.toString()+"%",
                                            style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text("Post Graduation %:",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(job.pgrad.toString()+"%",
                                            style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text("Number of Vacancies:",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(job.num_vacancy.toString(),
                                            style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text("Start Date:",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(job.start_date.split(" ")[0],
                                            style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text("Skills:",
                                            style: TextStyle(
                                                color: dark_blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(job.skills,
                                            style: TextStyle(
                                              color: dark_blue,
                                              fontSize: 15,
                                            )),
                                      ],
                                    ),
                                  ])
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() => customIcon = expanded);
                            },
                          ),
                        ]),
                      ),
                    
                      //apply button
                      
                    ]);
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return Center(child: Text("Something went wrong"));
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else{
              return Text("Something went wrong");
            }
          }),
    );
  }
}

class Box extends StatelessWidget {
  String title;
  Box({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 4),
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: box_color),
        child: Text(title,
            style: TextStyle(
                color: dark_blue, fontSize: 14, fontWeight: FontWeight.w400)),
      ),
    );
  }
}
