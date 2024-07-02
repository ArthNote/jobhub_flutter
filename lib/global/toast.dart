
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue =  Color.fromARGB(255, 9, 36, 78);
void showToast({required String message}){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: dark_blue,
    textColor: Colors.white,
    fontSize: 16.0
  );
}