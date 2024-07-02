// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial2/firebase/firebase_user.dart';
import 'package:tutorial2/pages/navigation/candidateNav.dart';
import 'package:tutorial2/pages/register.dart';

import '../firebase/firebase_auth.dart';
import '../global/toast.dart';
import 'forgotPassword.dart';
import 'navigation/recruiterNav.dart';

 const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
 const Color dark_blue =  Color.fromARGB(255, 9, 36, 78);

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: const Text('Log In',
          style: TextStyle(
            color: dark_blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Body(),
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  void dispose(){
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isSignIn = false;
  void signIn() async{
    setState(() {
      _isSignIn = true;
    });
    String email = emailController.text;
    String password = passController.text;

    if(email.isEmpty || password.isEmpty){
      showToast(message: "Please enter email and password");
      setState(() {
        _isSignIn = false;  
      });
    } else{
      User? user = await _auth.signInWithEmailPassword(email, password);

      setState(() {
        _isSignIn = false;  
      });

      if(user != null){
        String type  = await UserStuff().getType(user.uid);
        if(type == "Candidate"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CandidateNavigation()
            )
          );
        }else if(type == "Recruiter"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecruiterNavigation()
            )
          );
        }
      }else{
        print("Something went wrong");
      }
    }    
  }

  void goRegister(BuildContext context){
    //create navigator to open a LoginPage
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => RegisterPage())
    );
  }

  void goCandidate(BuildContext context){
    //create navigator to open a LoginPage
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => CandidateNavigation())
    );
  }

  bool isHidden = true;
  Icon pss = Icon(Icons.visibility_off);

  void toggleVisibility(){
    setState(() {
      isHidden = !isHidden;
      pss = isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility);
    });
  }

  void goTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        //logo
        Padding(
          padding: const EdgeInsets.fromLTRB(120, 30, 120, 10),
          child: Image(image: AssetImage("assets/logo.png")),
        ),
        //email input

        //add a  text input field
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 10),
          child: TextField(
            controller: emailController,
            
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
                fontWeight: FontWeight.w400
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: dark_blue, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "Enter your email",
            ), 
          ),
        ),
        //pass input
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          child: TextField(
            controller: passController,
            obscureText: isHidden,
            decoration: InputDecoration(
              labelText: "Password",
              //make the suffix icon clicable
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
                color: dark_blue,
                fontSize: 22,
                fontWeight: FontWeight.w400
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: dark_blue, width: 1.0, style: BorderStyle.solid),
                //create a border radius
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "Enter your password",
            ), 
          ),
        ),

        //reset password
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: GestureDetector(
                onTap: () => goTo(context, Password(title: "Forgot Password")) ,
                child: Text(
                  "Forgot Password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: dark_blue,
                    fontSize: 14,
                  )
                ),
              ),
            ),
          ],
        ),


        //login button
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
              )
            ),
            onPressed: () => signIn(), 
            child: _isSignIn ? CircularProgressIndicator(
              color: Colors.white,
            ) : Text("LOGIN"),
          ),
        ),

        //register text
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          //make a clickable text
          child: GestureDetector(
            onTap: () => goRegister(context),
            child: Text("Don't have an account? Register",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: dark_blue,
              ),
            )
          )
          
        ),


      ]
    );
  }
}