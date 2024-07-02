// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_user.dart';
import 'package:tutorial2/models/userModel.dart';
import 'package:tutorial2/pages/candidate/dashboard.dart';
import 'package:tutorial2/pages/login.dart';
import 'package:tutorial2/pages/navigation/candidateNav.dart';
import 'package:tutorial2/pages/navigation/recruiterNav.dart';

import '../firebase/firebase_auth.dart';
import '../global/toast.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: const Text(
          'Register',
          style: TextStyle(
            color: dark_blue,
            fontWeight: FontWeight.bold,
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
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  List<bool> genderSelected = [false, false];
  List<bool> typeSelected = [false, false];

  void goLogin(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  bool isHidden = true;
  Icon pss = Icon(Icons.visibility_off);

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
      pss = isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
    });
  }

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  //get selected item in togglebutton

  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    //unselect gender and type
    genderSelected = [false, false];
    typeSelected = [false, false];
    super.dispose();
  }

  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isSignUp = false;
  void signUp() async {
    setState(() {
      _isSignUp = true;
    });
    String email = emailController.text;
    String password = passController.text;
    String fname = fnameController.text;
    String lname = lnameController.text;
    String phone = phoneController.text;
    String about = aboutController.text;

    if (email.isEmpty ||
        password.isEmpty ||
        fname.isEmpty ||
        lname.isEmpty ||
        phone.isEmpty ||
        about.isEmpty ) {
      showToast(message: "All fields are mandatory");
      setState(() {
        _isSignUp = false;
      });
    }  else if (genderSelected[0] == false && genderSelected[1] == false) {
      showToast(message: "Please select a gender");
      setState(() {
        _isSignUp = false;
      });
    } else {
      User? user = await _auth.signUpWithEmailPassword(email, password);
      //get the current user id
      String uid = user!.uid;

      final newUser = UserM(
          uid,
          fname,
          lname,
          genderSelected[0] ? "Male" : "Female",
          email,
          phone,
          password,
          about,
          typeSelected[0] ? "Recruiter" : "Candidate", 
          0,0,0,"","",0);

      bool r = await UserStuff().createUserDetails(newUser);
      setState(() {
        _isSignUp = false;
      });
      if (user != null && r == true) {
        //if user choose type recruiter show a toast
        if (typeSelected[1] == true) {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => CandidateNavigation()));
        } else{
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecruiterNavigation()));
        }
        
      } else if (r == false) {
        showToast(message: "error add user to firestore");
      } else if (user == null) {
        showToast(message: "error create user");
      } else {
        showToast(message: "Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(children: <Widget>[
      //logo image
      Padding(
        padding: const EdgeInsets.fromLTRB(120, 30, 120, 10),
        child: Image(image: AssetImage("assets/logo.png")),
      ),

      //firstname input
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
                color: dark_blue, fontSize: 22, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
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
                color: dark_blue, fontSize: 22, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
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
          width: width,
          height: 57,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ToggleButtons(
            //make toggle buttons take whole width
            constraints: BoxConstraints(minWidth: (width/2)-40, minHeight: 57),
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
                color: dark_blue, fontSize: 22, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
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
                color: dark_blue, fontSize: 22, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: "Enter your phone number",
          ),
        ),
      ),

      //password input
      Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: TextField(
          controller: passController,
          obscureText: isHidden,
          decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              onPressed: () => toggleVisibility(),
              icon: pss,
              splashColor: dark_blue,
            ),
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            floatingLabelStyle: TextStyle(
                color: dark_blue, fontSize: 22, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: "Enter your password",
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
                color: dark_blue, fontSize: 22, fontWeight: FontWeight.w400),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: dark_blue, width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            //on focus fill the color indigo color
            filled: true,
            fillColor: Colors.white,
            hintText: "Enter your about me details",
          ),
        ),
      ),

      //account type input
      Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: Container(
          width: width,
          height: 57,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ToggleButtons(
            //make toggle buttons take whole width
            constraints: BoxConstraints(minWidth: (width/2)-40, minHeight: 57),
            splashColor: light_blue.withOpacity(0.5),
            children: const [Text("Recruiter"), Text("Candidate")],
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < typeSelected.length; i++) {
                  if (i == index) {
                    typeSelected[i] = true;
                  } else {
                    typeSelected[i] = false;
                  }
                }
              });
            },
            isSelected: typeSelected,
            fillColor: light_blue,
            selectedColor: Colors.white,
            renderBorder: false,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      //register button
      Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
        child: ElevatedButton(
          //make the button take more width
          style: ElevatedButton.styleFrom(
              //give it border radius of 20
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(width, 57),
              backgroundColor: dark_blue,
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          onPressed: () => signUp(),
          child: _isSignUp
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text("REGISTER"),
        ),
      ),

      //login text
      Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          //make a clickable text
          child: GestureDetector(
              onTap: () => goLogin(context),
              child: Text(
                "Already have an account? Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: dark_blue,
                ),
              ))),
    ]);
  }
}
