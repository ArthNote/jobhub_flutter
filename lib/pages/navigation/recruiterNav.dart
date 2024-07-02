// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tutorial2/pages/recruiter/chats.dart';

import '../recruiter/history.dart';
import '../recruiter/jobs.dart';
import '../recruiter/profile.dart';
import '../recruiter/search.dart';

 const Color light_blue = const Color.fromARGB(255, 1, 104, 230);
 const Color dark_blue =  Color.fromARGB(255, 9, 36, 78);
 const Color bg = Color.fromARGB(255, 243, 246, 253);

class RecruiterNavigation extends StatefulWidget {
  const RecruiterNavigation({super.key});

  @override
  State<RecruiterNavigation> createState() => _RecruiterNavigationState();
}

class _RecruiterNavigationState extends State<RecruiterNavigation> {

  int index = 0;
  late PageController pageController  = new PageController(initialPage: index);
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: index);

    pages = [
      RecruiterDashboard(pageController: pageController,),
      RecruiterSearch(),
      RecruiterHistory(),
      RecruiterChats(),
      RecruiterProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (pageIndex) {
          setState(() {
            index = pageIndex;
          });
        },
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: light_blue.withOpacity(0.3),
          backgroundColor: bg,
          elevation: 20,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              color: light_blue,
              fontWeight: FontWeight.w500,
              fontSize: 13
            ),
          )
        ),
        child: NavigationBar(
          height: 75,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: index,
          animationDuration: Duration(milliseconds: 550),
          onDestinationSelected: (pageIndex) {
            pageController.jumpToPage(pageIndex);
          },
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.work, color: light_blue),
              icon: Icon(Icons.work_outline, color: dark_blue),
              label: "Jobs",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.search, color: light_blue),
              icon: Icon(Icons.search, color: dark_blue),
              label: "Search",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.history, color: light_blue),
              icon: Icon(Icons.history, color: dark_blue),
              label: "History",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.chat, color: light_blue),
              icon: Icon(Icons.chat_outlined, color: dark_blue),
              label: "Chats",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person_2, color: light_blue),
              icon: Icon(Icons.person_2_outlined, color: dark_blue),
              label: "Profile",
            ),
          ],
        ),
      )
    );
  }
}