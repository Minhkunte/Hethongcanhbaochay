import 'package:flutter/material.dart';

class SliderMenu extends StatelessWidget {

  final double value;
  final void Function(double)? onChanged;
  final String text;
  final String text1;
  final String text2;
  final String text3;

  const SliderMenu({super.key, required this.value, required this.onChanged, required this.text, required this.text1, required this.text2, required this.text3});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54
              ),
            ),
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            max: 30,
            thumbColor: Colors.redAccent,
            activeColor: Colors.red[200],
            inactiveColor: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text1, style: const TextStyle(color: Colors.black54)),
                Text(text2, style: const TextStyle(color: Colors.black54)),
                Text(text3, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
