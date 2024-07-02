// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/pages/candidate/personalDetails.dart';
import 'package:tutorial2/pages/candidate/professionalDetails.dart';
import 'package:tutorial2/pages/forgotPassword.dart';

import '../../firebase/firebase_applications.dart';
import '../../firebase/firebase_user.dart';
import '../../global/toast.dart';
import '../../models/userModel.dart';
import '../first.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class CandidateProfile extends StatefulWidget {
  const CandidateProfile({super.key});

  @override
  State<CandidateProfile> createState() => _CandidateProfileState();
}

class _CandidateProfileState extends State<CandidateProfile> {
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
          'Profile',
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
  void goTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  int apps = 0;
  int views = 0;
  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
      countApplications();
      getViews();
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

  Future<UserM> getPersonal(String id) async {
    final user = await UserStuff().getPersonalData(uid);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPersonal(uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserM user = snapshot.data as UserM;
          return Column(
            children: [
              //profile image
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

              //full name + email
              Center(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(children: [
                  Text(
                    // make the first letter of the word capital
                    user.fname.substring(0, 1).toUpperCase() + user.fname.substring(1) + " " +
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
                    user.email,
                    style: TextStyle(color: light_blue, fontSize: 16),
                  )
                ]),
              )),

              //stats
              Center(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: IntrinsicHeight(
                    child: Row(
                        //space evenly and also center
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stat(value: "4.2", text: "Rating"),
                          Container(height: 24, child: VerticalDivider()),
                          Stat(value: apps.toString(), text: "Apps"),
                          Container(height: 30, child: VerticalDivider()),
                          Stat(value: views.toString(), text: "Views"),
                        ]),
                  ),
                ),
              )),

              //column of btns
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      //give it a box shadow
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(17, 24, 13, 0),
                    child: Column(children: [
                      MenuItem(
                          title: "Edit Personal Details",
                          onTap: () => goTo(context, personalDetails()),
                          icon: Icons.person_outline),
                      SizedBox(height: 10),
                      MenuItem(
                          title: "Edit Professional Details",
                          onTap: () => goTo(context, professionalDetails()),
                          icon: Icons.work_outline),
                      SizedBox(height: 10),
                      MenuItem(
                          title: "Settings",
                          onTap: () {},
                          icon: Icons.settings_outlined),
                      SizedBox(height: 10),
                      MenuItem(
                          title: "Change Password",
                          onTap: () =>
                              goTo(context, Password(title: "Change Password")),
                          icon: Icons.lock_outline),
                      //edit personal details
                    ]),
                  ),
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class Stat extends StatelessWidget {
  const Stat({super.key, required this.value, required this.text});
  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                  color: dark_blue, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                  color: light_blue, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ]),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: dark_blue.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14, color: dark_blue, fontWeight: FontWeight.w500),
      ),
      trailing: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            //color: Colors.grey
            ),
        child: Icon(
          Icons.arrow_forward_ios,
          color: dark_blue,
          size: 14,
        ),
      ),
    );
  }
}
