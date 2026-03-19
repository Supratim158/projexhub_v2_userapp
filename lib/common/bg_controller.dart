import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/constants.dart';

class BgController extends StatelessWidget {
  const BgController({super.key, required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        color: color,
        image: const DecorationImage(
            image: AssetImage("assets/images/custom_bg.png"),
          fit: BoxFit.cover,
          opacity: .3
        )
      ),
      child: child,
    );
  }
}
