import 'package:flutter/material.dart';

class LongButton extends StatelessWidget {

  final Function()? onTap;
  final String text;
  final double height;
  final double length;

  const LongButton({
    super.key, 
    required this.onTap,
    required this.text,
    required this.height,
    required this.length,
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height),
        margin: EdgeInsets.symmetric(horizontal: length),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}