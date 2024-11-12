import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:laptrinhflutterappdoan/components/controller_menu.dart';
import '../components/slider_menu.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  bool isSwitchedTD = false;
  bool isSwitchedTC = false;
  double heating = 12;
  double fan = 15;

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  void TuDong(value) {
    setState(() {
      isSwitchedTD = value;
      toggleSwitchTD(isSwitchedTD);
    });
  }

  void ThuCong(value) {
    setState(() {
      isSwitchedTC = value;
      toggleSwitchTC(isSwitchedTC);
    });
  }

  final DatabaseReference _Chucnang = FirebaseDatabase.instance.ref('TUDONG');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HI, YOU',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: logOut,
                    icon: Icon(
                      Icons.logout,
                      color: Colors.black54,
                      size: 28,
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Image.asset(
                        'assets/images/banner.png',
                        scale: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Smart fire alarm',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ControllerMenu(
                          icon: 'assets/images/smoke.png',
                          title: 'Tự Động',
                          value: isSwitchedTD,
                          onToggle: TuDong,
                        ),
                        ControllerMenu(
                          icon: 'assets/images/temperature.png',
                          title: 'Thủ Công',
                          value: isSwitchedTC,
                          onToggle: ThuCong,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SliderMenu(
                      value: heating,
                      onChanged: (newHeating){
                        setState(() {
                          heating = newHeating;
                        });
                      },
                      text: 'Temperature',
                      text1: '0\u00B0C',
                      text2: '30\u00B0C',
                      text3: '60\u00B0C',
                    ),
                    const SizedBox(height: 20),
                    SliderMenu(
                      value: fan,
                      onChanged: (newfan){
                        setState(() {
                          fan = newfan;
                        });
                      },
                      text: 'Smoke',
                      text1: '0ppm',
                      text2: '500ppm',
                      text3: '100ppm',
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> toggleSwitchTD(bool isSwitchedTD) async {
    await _Chucnang.child('BaoChayTD').set(isSwitchedTD);
  }

  Future<void> toggleSwitchTC(bool isSwitchedTC) async {
    await _Chucnang.child('BaoChayTC').set(isSwitchedTC);
  }
}