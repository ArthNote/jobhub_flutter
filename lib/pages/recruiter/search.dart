// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_user.dart';
import 'package:tutorial2/pages/recruiter/candidatePage.dart';

import '../../models/userModel.dart';
import '../first.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class RecruiterSearch extends StatelessWidget {
  const RecruiterSearch({super.key});

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
          'Find a Candidate',
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
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController searchController = TextEditingController();
  List<UserM> foundUsers = [];
  String searchTerm = "";
  //do a search method
   Future<List<UserM>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final users = await UserStuff().displayUsers();
     List<UserM> results = [];
     if (enteredKeyword.isEmpty) {
       return results = users;
     } else {
       results = users
           .where((user) => 
            user.fname
               .toLowerCase()
               .contains(enteredKeyword.toLowerCase()) ||
            user.lname
               .toLowerCase()
               .contains(enteredKeyword.toLowerCase()) ||
            user.skills
               .toLowerCase()
               .contains(enteredKeyword.toLowerCase()) ||
            user.specs
               .toLowerCase()
               .contains(enteredKeyword.toLowerCase()) ||
            user.exp.toString()
               .toLowerCase()
               .contains(enteredKeyword.toLowerCase())
            ).toList();
     }
     return foundUsers = results;
   }

  void goTo(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CandidatePage(user_id: id,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //search field
      Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          onChanged: (value){
            setState(() {
              searchTerm = value;
            });
          },
          controller: searchController,
          decoration: InputDecoration(
            labelText: "Search",
            border: OutlineInputBorder(borderSide: BorderSide()),
            filled: true,
            hintText: "Name, Skills, Specialization, Experience",
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

      //list view
      FutureBuilder<List<UserM>>(
        future: runFilter(searchTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<UserM> users = snapshot.data!;
              return Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return GestureDetector(
                        onTap: () => goTo(context, user.id),
                        child: UserCard(
                          fname: user.fname, 
                          lname: user.lname, 
                          specs: user.specs, 
                          exp: user.exp
                        )
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

class UserCard extends StatefulWidget {
  String fname = "";
  String lname = "";
  String specs = "";
  int exp = 0;

  UserCard({
    super.key,
    required this.fname,
    required this.lname,
    required this.specs,
    required this.exp,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    String fullname = widget.fname.substring(0, 1).toUpperCase() + widget.fname.substring(1) + " " +
                        widget.lname.substring(0, 1).toUpperCase() +
                        widget.lname.substring(1);
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Image.asset(
                    "assets/sydney.png",
                    height: 70,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(fullname,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: dark_blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(widget.specs,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: light_blue,
                            fontSize: 15,
                          )),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(widget.exp.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: dark_blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Text("Years",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: dark_blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
