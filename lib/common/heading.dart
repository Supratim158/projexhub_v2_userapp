import 'package:app/common/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../constants/constants.dart';
import 'app_style.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.text, this.onTap, this.trailing});

  final String text;
  final void Function()? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: text, 
            style: appStyle(18, textWhite, FontWeight.bold)
          ),

          GestureDetector(
            onTap: onTap,
            child: trailing ?? Icon(Icons.arrow_forward_ios, color: textGrey, size: 20.sp,),
          )
        ],
      ),
    );
  }
}