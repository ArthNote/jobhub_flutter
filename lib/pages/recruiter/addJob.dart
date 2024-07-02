// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorial2/models/jobModel.dart';
import 'package:tutorial2/pages/navigation/recruiterNav.dart';

import '../../firebase/firebase_auth.dart';
import '../../firebase/firebase_jobs.dart';
import '../../global/toast.dart';

const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
const Color dark_blue = Color.fromARGB(255, 9, 36, 78);

class AddJob extends StatelessWidget {
  const AddJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark_blue),
        title: const Text(
          'Add Job',
          style: TextStyle(
            color: dark_blue,
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
  TextEditingController companyController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController sdateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController vacancyController = TextEditingController();
  TextEditingController minexpController = TextEditingController();
  TextEditingController maxexpController = TextEditingController();
  TextEditingController gradController = TextEditingController();
  TextEditingController pgradController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController minpayController = TextEditingController();
  TextEditingController maxpayController = TextEditingController();
  TextEditingController respController = TextEditingController();

  final JobStuff jStuff = JobStuff();
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
  }

  String adate = "";
  bool isAdding = false;
  void add() async {
    setState(() {
      isAdding = true;
    });
    String company = companyController.text;
    String title = titleController.text;
    String sdate = sdateController.text;
    String desc = descController.text;
    String location = locationController.text;
    String type = typeController.text;
    int minpay = int.parse(minpayController.text);
    int maxpay = int.parse(maxpayController.text);
    int minexp = int.parse(minexpController.text);
    int maxexp = int.parse(maxexpController.text);
    int grad = int.parse(gradController.text);
    int pgrad = int.parse(pgradController.text);
    int vacancy = int.parse(vacancyController.text);
    String skills = skillsController.text;
    String time = timeController.text;
    String resp = respController.text;
    //get today's date, just the date no time
    String pub_date = DateTime.now().toString();

    if (company.isEmpty ||
        title.isEmpty ||
        sdate.isEmpty ||
        desc.isEmpty ||
        location.isEmpty ||
        selectedType == "Select a Type" ||
        minpayController.text.isEmpty ||
        maxpayController.text.isEmpty ||
        minexpController.text.isEmpty ||
        maxexpController.text.isEmpty ||
        gradController.text.isEmpty ||
        pgradController.text.isEmpty ||
        skills.isEmpty ||
        selectedTime == "Select a Time" ||
        resp.isEmpty ||
        vacancyController.text.isEmpty) {
      showToast(message: "All fields are mandatory");
      setState(() {
        isAdding = false;
      });
    } else {
      final newJob = Job(
          "",
          company,
          title,
          adate,
          desc,
          vacancy,
          minexp,
          maxexp,
          grad,
          pgrad,
          skills,
          location,
          selectedType,
          selectedTime,
          minpay,
          maxpay,
          resp,
          pub_date,
          uid);
      bool r = await jStuff.createJob(newJob);
      setState(() {
        isAdding = false;
      });
      if (r == true) {
        showToast(message: "Job added successfully");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RecruiterNavigation()));
      } else {
        showToast(message: "Job not added");
      }
    }
  }

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        sdateController.text = _picked.toString().split(" ")[0];
        adate = _picked.toString();
      });
    }
  }

  String selectedType = "Select a Type";
  String selectedTime = "Select a Time";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        TextInput(
            title: "Company",
            controller: companyController,
            icon: Icons.business,
            type: TextInputType.text),
        TextInput(
            title: "Title",
            controller: titleController,
            icon: Icons.workspace_premium,
            type: TextInputType.text),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
          child: TextField(
            onTap: () {
              selectDate();
            },
            readOnly: true,
            controller: sdateController,
            decoration: InputDecoration(
                labelText: "Start Date",
                suffixIcon: Icon(Icons.date_range),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
                floatingLabelStyle: TextStyle(
                    color: dark_blue,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
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
                hintText: "Enter the Start Date"),
          ),
        ),
        TextInput(
            title: "Description",
            controller: descController,
            icon: Icons.description,
            type: TextInputType.text),
        TextInput(
            title: "Location",
            controller: locationController,
            icon: Icons.location_on,
            type: TextInputType.text),
        /*TextInput(
            title: "Type",
            controller: typeController,
            icon: Icons.location_city,
            type: TextInputType.text),*/
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButton<String>(
              //remove the underline
              underline: Container(),
              iconDisabledColor: Colors.grey,
              //H20A1654779JBMD
              hint: Text("Type"),
              focusColor: Colors.white,
              dropdownColor: Colors.white,
              value: selectedType,
              isExpanded: true,
              icon: Icon(Icons.location_city),
              onChanged: (String? newValue) {
                setState(() {
                  selectedType = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: "Select a Type",
                  child: Text(
                    "Select a Type",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                DropdownMenuItem(
                  value: "Hybrid",
                  child: Text("Hybrid"),
                ),
                DropdownMenuItem(
                  value: "On-Site",
                  child: Text("On-Site"),
                ),
                DropdownMenuItem(
                  value: "Remote",
                  child: Text("Remote"),
                ),
              ],
            ),
          ),
        ),
        TextInput(
            title: "Min. Pay",
            controller: minpayController,
            icon: Icons.attach_money,
            type: TextInputType.number),
        TextInput(
            title: "Max. Pay",
            controller: maxpayController,
            icon: Icons.attach_money,
            type: TextInputType.number),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButton<String>(
              //remove the underline
              underline: Container(),
              iconDisabledColor: Colors.grey,
              //H20A1654779JBMD
              hint: Text("Time"),
              focusColor: Colors.white,
              dropdownColor: Colors.white,
              value: selectedTime,
              isExpanded: true,
              icon: Icon(Icons.timer),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTime = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: "Select a Time",
                  child: Text(
                    "Select a Time",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                DropdownMenuItem(
                  value: "Full-Time",
                  child: Text("Full-Time"),
                ),
                DropdownMenuItem(
                  value: "Part-Time",
                  child: Text("Part-Time"),
                ),
                DropdownMenuItem(
                  value: "Freelance",
                  child: Text("Freelance"),
                ),
                DropdownMenuItem(
                  value: "Contract",
                  child: Text("Contract"),
                ),
              ],
            ),
          ),
        ),
        TextInput(
            title: "Skills",
            controller: skillsController,
            icon: Icons.settings_applications,
            type: TextInputType.multiline),
        TextInput(
            title: "Min. Experience",
            controller: minexpController,
            icon: Icons.work_history,
            type: TextInputType.number),
        TextInput(
            title: "Max. Experience",
            controller: maxexpController,
            icon: Icons.work_history,
            type: TextInputType.number),
        TextInput(
            title: "Graduation %",
            controller: gradController,
            icon: Icons.percent,
            type: TextInputType.number),
        TextInput(
            title: "Post Graduation %",
            controller: pgradController,
            icon: Icons.percent,
            type: TextInputType.number),
        TextInput(
            title: "No. of Vacancy",
            controller: vacancyController,
            icon: Icons.weekend,
            type: TextInputType.number),
        TextInput(
            title: "Responsibilities",
            controller: respController,
            icon: Icons.list,
            type: TextInputType.multiline),
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
            onPressed: () => add(),
            child: isAdding
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text("ADD"),
          ),
        ),
      ]),
    );
  }
}

class TextInput extends StatefulWidget {
  String title;
  TextEditingController controller;
  IconData icon;
  TextInputType type;

  TextInput(
      {super.key,
      required this.title,
      required this.controller,
      required this.icon,
      required this.type});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.type,
        minLines: 1,
        maxLines: 100,
        decoration: InputDecoration(
          labelText: widget.title,
          suffixIcon: Icon(widget.icon),
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
          hintText: "Enter the " +
              widget.title.substring(0, 1).toUpperCase() +
              widget.title.substring(1),
        ),
      ),
    );
  }
}
