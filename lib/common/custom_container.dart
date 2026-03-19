import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({super.key, required this.containerContent, this.color, this.gradient});

  final Widget containerContent;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: color,
            gradient: color == null 
              ? (gradient ?? const LinearGradient(
                  colors: [
                    bgDark1,
                    bgDark2,
                    bgDark3,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ))
              : null,
          ),
          child: SingleChildScrollView(
            child: containerContent,
          ),
        ),
      ),
    );
  }
}
