import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class AnimatedButton extends StatefulWidget {

  final String text;
  final VoidCallback onTap;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {

  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          scale = 0.95;
        });
      },
      onTapUp: (_) {
        setState(() {
          scale = 1;
        });
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(scale),
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff6C63FF),
              Color(0xff9C27B0)
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: accentPurple,
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}