import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  final String title;
  final String icon;
  const CardMenu({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40),
      width: 170,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Image.asset(icon, scale: 2.0),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 17
            ),
          )
        ],
      ),
    );
  }
}
