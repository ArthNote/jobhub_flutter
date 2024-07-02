// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../firebase/firebase_auth.dart';
import '../global/toast.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class Password extends StatelessWidget {
  String title = "";

  Password({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: Text(
          title,
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  final FirebaseAuthService _auth = FirebaseAuthService();
  bool sending = false;
  void passwordReset() async{
    setState(() {
      sending = true;
    }); 
    String email = emailController.text;
    if(email.isEmpty){
      showToast(message: "Please enter your email");
    } else{
      await _auth.changePassword(email);
      emailController.clear();
    }
  }

  bool check = false;
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
          child: Text(
            "Enter your email address and we will send you a link to reset your password",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark_blue,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              //make the suffix icon clicable
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
                //create a border radius
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "Enter your Email",
            ),
          ),
        ),
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
            onPressed: () => passwordReset(),
            child: check
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text("SEND LINK"),
          ),
        ),
      ],
    );
  }
}
