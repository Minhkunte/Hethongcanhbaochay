import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ControllerMenu extends StatelessWidget {
  final String icon;
  final bool value;
  final String title;
  final void Function(bool) onToggle;

  const ControllerMenu({super.key, required this.icon, required this.onToggle, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      width: 170,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Image.asset(icon, scale: 2.0),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 17
            ),
          ),
          const SizedBox(height: 20),
          FlutterSwitch(
            value: value,
            width: 90.0,
            height: 40.0,
            valueFontSize: 20.0,
            toggleSize: 35.0,
            borderRadius: 30.0,
            padding: 5.0,
            activeColor: Colors.redAccent,
            showOnOff: true,
            onToggle: onToggle,
          )
        ],
      ),
    );
  }
}

