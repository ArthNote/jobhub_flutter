// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/models/userModel.dart';

import '../../firebase/firebase_user.dart';
import '../../global/toast.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class personalDetails extends StatelessWidget {
  const personalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: Text(
          'Personal Details',
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
  List<bool> genderSelected = [false, false];

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  @override
  void initState() {
    if (currentUser != null) {
      uid = currentUser!.uid;
      final user = getPersonal(uid);
      /*setState(() {
        loading = true;
        
      });
      user.then((value) {
        fnameController.text = value.fname;
        lnameController.text = value.lname;
        emailController.text = value.email;
        phoneController.text = value.phone;
        aboutController.text = value.about;
        setState(() {
          if (value.gender == "Male") {
            genderSelected = [true, false];
          } else {
            genderSelected = [false, true];
          }
        });
      });*/
    }
    super.initState();
  }

  Future<UserM> getPersonal(String id) async {
    final user = await UserStuff().getPersonalData(uid);

    return user;
  }

  bool isSave = false;
  void update(String pss, String type, int grad, int pgrad, int exp,
      String specs, String skills, int views) async {
    setState(() {
      isSave = true;
    });
    String email = emailController.text;
    String fname = fnameController.text;
    String lname = lnameController.text;
    String phone = phoneController.text;
    String about = aboutController.text;

    if (email.isEmpty ||
        fname.isEmpty ||
        lname.isEmpty ||
        phone.isEmpty ||
        about.isEmpty) {
      showToast(message: "All fields are mandatory");
      setState(() {
        isSave = false;
      });
    } else if (genderSelected[0] == false && genderSelected[1] == false) {
      showToast(message: "Please select a gender");
      setState(() {
        isSave = false;
      });
    } else {
      String uid = currentUser!.uid;
      final newUser = UserM(
          uid,
          fname,
          lname,
          genderSelected[0] ? "Male" : "Female",
          email,
          phone,
          pss,
          about,
          type,
          grad,
          pgrad,
          exp,
          specs,
          skills,
          views);
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

  bool yes = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 30),
      child: FutureBuilder(
          future: getPersonal(uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.hasData) {
                UserM user = snapshot.data as UserM;
                fnameController.text = user.fname;
                lnameController.text = user.lname;
                emailController.text = user.email;
                phoneController.text = user.phone;
                aboutController.text = user.about;
                //get the gender and assign whats needed

                return Column(children: [
                  //profile photo
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Stack(
                        children: [
                          SizedBox(
                              height: 120,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset('assets/sydney.png'),
                              )),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: dark_blue),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // first name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 40, 40, 10),
                    child: TextField(
                      controller: fnameController,
                      decoration: InputDecoration(
                        labelText: "First Name",
                        suffixIcon: Icon(Icons.person),
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
                        hintText: "Enter your first name",
                      ),
                    ),
                  ),

                  //lastname input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextField(
                      controller: lnameController,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        suffixIcon: Icon(Icons.person),
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
                        hintText: "Enter your last name",
                      ),
                    ),
                  ),

                  //gender input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Container(
                      width: 320,
                      height: 57,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ToggleButtons(
                        //make toggle buttons take whole width
                        constraints:
                            const BoxConstraints(minWidth: 156, minHeight: 57),
                        splashColor: light_blue.withOpacity(0.5),
                        children: const [Text("Male"), Text("Female")],
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < genderSelected.length; i++) {
                              if (i == index) {
                                genderSelected[i] = true;
                              } else {
                                genderSelected[i] = false;
                              }
                            }
                          });
                        },
                        isSelected: genderSelected,
                        fillColor: light_blue,
                        selectedColor: Colors.white,
                        renderBorder: false,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  //email input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        suffixIcon: Icon(Icons.email),
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
                        hintText: "Enter your email",
                      ),
                    ),
                  ),

                  //phone number input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        suffixIcon: Icon(Icons.phone),
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
                        hintText: "Enter your phone number",
                      ),
                    ),
                  ),

                  //about input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: TextFormField(
                      controller: aboutController,
                      minLines: 1,
                      maxLines: 100,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: "About Me",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.info),
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
                        hintText: "Enter your about me details",
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
                      onPressed: () => update(
                          user.password,
                          user.type,
                          user.grad,
                          user.pgrad,
                          user.exp,
                          user.specs,
                          user.skills,
                          user.views),
                      child: isSave
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text("UPDATE PROFILE"),
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
    );
  }
}
