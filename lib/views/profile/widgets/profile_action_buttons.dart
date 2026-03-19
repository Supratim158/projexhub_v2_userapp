import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../common/app_style.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Primary 'Edit Profile' Button
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFF0F52FF), // Vivid blue
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F52FF).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Center(
              child: Text(
                "Edit Profile",
                style: appStyle(16, Colors.white, FontWeight.bold),
              ),
            ),
          ),
        ),
        
        SizedBox(width: 16.w),
        
        // Share Button
        Container(
          width: 50.h,
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E), // Dark surface
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Center(
            child: Icon(
              AntDesign.sharealt,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        )
      ],
    );
  }
}
