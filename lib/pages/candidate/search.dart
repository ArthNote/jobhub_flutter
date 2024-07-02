// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_this, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorial2/firebase/firebase_bookmarks.dart';
import 'package:tutorial2/firebase/firebase_jobs.dart';
import 'package:tutorial2/global/toast.dart';
import 'package:tutorial2/models/bookmarkModel.dart';
import 'package:tutorial2/pages/candidate/jobPage.dart';

import '../../models/jobModel.dart';
import '../first.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class CandidateSearch extends StatefulWidget {
  const CandidateSearch({super.key});

  @override
  State<CandidateSearch> createState() => _CandidateSearchState();
}

class _CandidateSearchState extends State<CandidateSearch> {
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
          'Find A Job',
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
  TextEditingController searchController = TextEditingController();
  List<Job> foundJobs = [];
  String searchTerm = "";
  bool isSaved = false;

  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  Set<String> bookmarkedJobIds = Set<String>();

  Future<void> loadBookmarkedJobs() async {
    List<BookMark> bookmarks = await BookmarkStuff().displayBookmarks(uid);
    setState(() {
      bookmarkedJobIds = Set<String>.from(bookmarks.map((bookmark) => bookmark.jid));
    });
  }

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
      loadBookmarkedJobs();
    }
  }

  /*Future<void> checkBookmarkStatus() async {
    for (var job in foundJobs) {
      bool isBookmarkeda = bookmarkedJobIds.contains(job.id);
      if (isBookmarkeda == true) {
        isSaved = isBookmarkeda;
      } else{
        bool isBookmarked = await BookmarkStuff().checkBookmark(uid, job.id);
        isSaved = isBookmarked;
      }
    }
  }*/

  //bookmark a job
  void bookmarkJob(BuildContext context, String jid, String title, String company, String location, String type, String time, int min_exp, int max_exp, String date) async {
    final newB = BookMark("", uid, jid, title, company, location, type, time, min_exp, max_exp, date);
    bool check = await BookmarkStuff().checkBookmark(uid, jid);
    if (check == true) {
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
                  removeBookmark(jid);
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    }
    else{
      bool r = await BookmarkStuff().bookmarkJob(newB);
      if (r == true) {
        showToast(message: "Job bookmarked successfully");
        setState(() {loadBookmarkedJobs();});
      } else {
        showToast(message: "Something went wrong");
      }
    }
  }

  void removeBookmark(String jid) async {
    bool result = await BookmarkStuff().removeBookmark(uid,jid);
    if (result) {
      showToast(message: "Bookmark removed successfully");
      setState(() {
        loadBookmarkedJobs();
      });
    } else {
      showToast(message: "Something went wrong while removing bookmark");
    }
  }

  Future<List<Job>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final jobs = await JobStuff().displayAllJobs();
    List<Job> results = [];
    if (enteredKeyword.isEmpty) {
      return results = jobs;
    } else {
      results = jobs
          .where((job) =>
              job.title.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              job.company
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              job.skills.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              job.min_exp
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              job.max_exp
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundJobs = results;
  }

  void goTo(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobPage(job_id: id)),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //search field
      Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          onChanged:(value){
            setState(() {
              searchTerm = value;
            });
          },
          controller: searchController,
          decoration: InputDecoration(
            labelText: "Search",
            border: OutlineInputBorder(borderSide: BorderSide()),
            filled: true,
            hintText: "Job, Company, Skills, Experience...",
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(Icons.cancel_rounded),
              onPressed: () => searchController.clear(),
            ),
            prefixIcon: Icon(Icons.search),
            floatingLabelStyle: TextStyle(
                color: dark_blue, fontSize: 18, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
              //create a border radius
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      FutureBuilder<List<Job>>(
        future: runFilter(searchTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Job> jobs = snapshot.data!;
              return Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      var job = jobs[index];
                      bool isBookmarked = bookmarkedJobIds.contains(job.id);
                      int h;
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
                      } else if(w > 1 && w < month) {
                        date = w.toString() + " days ago";
                      } else if(w == month){
                        date = "1 month ago";
                      } else if(w > month && w < year){
                        //check if w divided by month equals a whole number
                        if(w % month == 0){
                          date = (w/month).toString() + " months ago";
                        } else {
                          date = (w/month).floor().toString() + " months ago";
                        }
                      } else if(w == year){
                        date = "1 year ago";
                      } else if( w > year){
                        if(w % year == 0){
                          date = (w/year).toString() + " years ago";
                        } else {
                          date = (w/year).floor().toString() + " years ago";
                        }
                      } else{
                        date = "error";
                      }
                      return GestureDetector(
                        onTap: () => goTo(context, job.id),
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
                                                child: Text(job.title,
                                                    style: TextStyle(
                                                        color: dark_blue,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16)),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 2),
                                                  child: Text(
                                                      job.company + " - " + job.location,
                                                      style: TextStyle(
                                                          color: dark_blue, fontSize: 14)))
                                            ]),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                        child: IconButton(
                                          icon: isBookmarked? Icon(Icons.bookmark, color: light_blue) : Icon(Icons.bookmark_border, color: dark_blue,),
                                          onPressed: () => bookmarkJob(context, job.id, job.title, job.company, job.location, job.type, job.time, job.min_exp, job.max_exp, date),
                                        ))
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
                                      child: Text(job.time,
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
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(9, 6, 9, 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Color.fromARGB(255, 243, 246, 253)),
                                      child: Text(job.type,
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
        },
      )
    ]);
  }
}

