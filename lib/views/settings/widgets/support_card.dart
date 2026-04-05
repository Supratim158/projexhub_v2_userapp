import 'package:app/common/app_style.dart';
import 'package:app/common/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({super.key, required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 50.h,
              width: 50.w,
              color: Colors.blueAccent.withOpacity(0.2),
              child: Center(
                child: Icon(icon, color: Colors.blueAccent, size: 30.sp),
              ),
            ),
          ),
      
          SizedBox(width: 10.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: title,
                style: appStyle(13, Colors.white, FontWeight.w600),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24.sp),
        ],
      ),
    );
  }
}