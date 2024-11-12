import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../components/card_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DatabaseReference _temperatureReference;
  late DatabaseReference _smokeReference;

  double _temperatureValue = 0.0;
  int _smokeValue = 0;

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();

    // Kết nối đến Firebase và thiết lập tham chiếu
    _temperatureReference = FirebaseDatabase.instance.ref('TUDONG').child('Nhietdo');
    _smokeReference = FirebaseDatabase.instance.ref('TUDONG').child('Khoi');

    // Lắng nghe sự thay đổi dữ liệu nhiệt độ và khói
    _temperatureReference.onValue.listen((DataSnapshot) {
      setState(() {
        _temperatureValue = double.parse(DataSnapshot.snapshot.value.toString());
      });
    });

    _smokeReference.onValue.listen((DataSnapshot) {
      setState(() {
        _smokeValue = int.parse(DataSnapshot.snapshot.value.toString());
      });
    });
  }

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
                        CardMenu(
                          icon: 'assets/images/smoke.png',
                          title: 'Smoke: $_smokeValue ppm',
                        ),
                        CardMenu(
                          icon: 'assets/images/temperature.png',
                          title: 'Temp: $_temperatureValue ℃',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}