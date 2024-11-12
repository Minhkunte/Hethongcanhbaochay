import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:laptrinhflutterappdoan/pages/profile_page.dart';
import 'controller_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List _pages = [
    HomePage(),
    ControllerPage(),
    ProfilePage(),
  ];
  int currenIndex = 0;
  void goToPage(index) {
    setState(() {
      currenIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currenIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0
          ),
          child: GNav(
            backgroundColor: Colors.black54,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.red.shade200,
            gap: 8,
            onTabChange: (index) => goToPage(index),
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.local_fire_department_outlined,
                text: 'Controller',
              ),
              GButton(
                icon: Icons.account_circle_outlined,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}