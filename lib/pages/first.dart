// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tutorial2/pages/login.dart';
import 'package:tutorial2/pages/register.dart';

final Color dark_blue = Color.fromARGB(255, 9, 36, 78);


class MainPage extends StatelessWidget {
  MainPage({super.key});

  final Color light_blue = Color.fromARGB(255, 1, 104, 230);

  void goLogin(BuildContext context){
    //create navigator to open a LoginPage
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => LoginPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          //align the title to the right
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15
          )
        ),
        //add a login button on the far right
        actions: [
          IconButton(
            onPressed: () => goLogin(context),
            splashColor: light_blue,
            tooltip: "Login",
            icon: Icon(
              Icons.login, 
              color: dark_blue,
            )
          )
        ],
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        
      ),
      body: MainBody(),
    );
  }
}

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  void goRegister(BuildContext context){
    //create navigator to open a LoginPage
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => RegisterPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //image
        //remove padding on top
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Image.asset("assets/main-illu.png"),
        ),
        
        //main text
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0), 
          child: Text("Find And Land Your Next Jobs",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold,
              color: dark_blue,
            ),
          ),
        ),
        
        //smaller text
        Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 30, 0), 
          child: Text("Daily job postings at your fingertips - never miss out on your next career move.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: dark_blue,
            ),
          ),
        ),
        
        //get started button

        //create abutton and give it get started title
        Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0), 
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  //make the button take more width
                  style: ElevatedButton.styleFrom(
                    //give it border radius of 20
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //minimumSize: Size(320, 50),
                    minimumSize: Size(MediaQuery.of(context).size.width-60, 55),
                    backgroundColor: dark_blue,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  onPressed:  () => goRegister(context), 
                  child: Text("GET STARTED"),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}


