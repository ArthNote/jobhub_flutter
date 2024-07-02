// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../firebase/firebase_user.dart';
import '../../global/toast.dart';
import '../../models/userModel.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class professionalDetails extends StatelessWidget {
  const professionalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: Text(
          'Professional Details',
          style: TextStyle(
            color: dark_blue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
  TextEditingController gradController = TextEditingController();
  TextEditingController pgradController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController specsController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  @override
  void initState() {
    if (currentUser != null) {
      uid = currentUser!.uid;
      final user = getPersonal(uid);
    }
    super.initState();
  }

  Future<UserM> getPersonal(String id) async {
    final user = await UserStuff().getPersonalData(uid);
    return user;
  }

  bool isSave = false;

  void update(String fname, String lname, String gender, String email,
      String phone, String about, String pss, String type, int views) async {
    setState(() {
      isSave = true;
    });
    int grad = int.parse(gradController.text);
    int pgrad = int.parse(pgradController.text);
    int exp = int.parse(expController.text);
    String specs = specsController.text;
    String skills = skillsController.text;

    if (specs.isEmpty ||
        skills.isEmpty ||
        gradController.text.isEmpty ||
        pgradController.text.isEmpty ||
        expController.text.isEmpty) {
      showToast(message: "All fields are mandatory");
      setState(() {
        isSave = false;
      });
    } else {
      String uid = currentUser!.uid;
      final newUser = UserM(uid, fname, lname, gender, email, phone, pss, about,
          type, grad, pgrad, exp, specs, skills,views);
      bool r = await UserStuff().updatePersonalData(newUser);
      setState(() {
        isSave = false;
      });
      if (r == true) {
        showToast(message: "Profile Updated Successfully");
      } else if (r == false) {
        showToast(message: "error to update profile");
      } else {
        showToast(message: "Something went wrong");
      }
    }
  }

  bool u = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: FutureBuilder(
            future: getPersonal(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.hasData) {
                  UserM user = snapshot.data as UserM;
                  specsController.text = user.specs;
                  skillsController.text = user.skills;
                  gradController.text = user.grad.toString();
                  pgradController.text = user.pgrad.toString();
                  expController.text = user.exp.toString();
                  return Column(children: [
                    // first name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
                      child: TextField(
                        controller: gradController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Graduation Percentage",
                          suffixIcon: Icon(Icons.percent),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          floatingLabelStyle: TextStyle(
                              color: dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: dark_blue,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter your Graduation Percentage",
                        ),
                      ),
                    ),

                    //lastname input
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: TextField(
                        controller: pgradController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Post Graduation Percentage",
                          suffixIcon: Icon(Icons.percent),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          floatingLabelStyle: TextStyle(
                              color: dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: dark_blue,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Post Graduation Percentage",
                        ),
                      ),
                    ),

                    //email input
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: TextField(
                        controller: expController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Years of Experience",
                          suffixIcon: Icon(Icons.work_history),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          floatingLabelStyle: TextStyle(
                              color: dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: dark_blue,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter your Years of Experience",
                        ),
                      ),
                    ),

                    //phone number input
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: TextField(
                        controller: specsController,
                        decoration: InputDecoration(
                          labelText: "Specialization",
                          suffixIcon: Icon(Icons.workspace_premium),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          floatingLabelStyle: TextStyle(
                              color: dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: dark_blue,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter your Specialization",
                        ),
                      ),
                    ),

                    //about input
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: TextFormField(
                        controller: skillsController,
                        minLines: 1,
                        maxLines: 100,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "Skills",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings_applications),
                            splashColor: dark_blue,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                          floatingLabelStyle: TextStyle(
                              color: dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: dark_blue,
                                width: 1.0,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          //on focus fill the color indigo color
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter your Skills",
                        ),
                      ),
                    ),

                    //save button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                      child: ElevatedButton(
                        //make the button take more width
                        style: ElevatedButton.styleFrom(
                            //give it border radius of 20
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(320, 57),
                            backgroundColor: dark_blue,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () => update(user.fname, user.lname, user.gender, user.email, user.phone, user.about, user.password, user.type, user.views),
                        child: isSave
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text("SAVE"),
                      ),
                    ),
                  ]);
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: Text("Something went wrong"));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
