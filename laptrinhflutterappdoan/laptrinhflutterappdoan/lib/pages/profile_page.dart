import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Profile Page', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red[300])),
      ),
    );
  }
}
