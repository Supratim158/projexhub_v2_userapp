import 'package:app/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.user});

  final LoginResponse? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Glowing Avatar
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const SweepGradient(
              colors: [
                Colors.blueAccent,
                Colors.purpleAccent,
                Colors.blueAccent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: CircleAvatar(
            radius: 50.r,
            backgroundColor: const Color(0xFF1E1E2E), // Fallback inner color
            backgroundImage: NetworkImage(user!.profile),
          ),
        ),

        SizedBox(height: 16.h),

        // Name and Verified Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user!.userName ?? "Username",
              style: appStyle(22, Colors.white, FontWeight.bold),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.verified,
              color: Colors.blueAccent,
              size: 20.sp,
            )
          ],
        ),

        SizedBox(height: 8.h),

        // Subtitle
        Text(
          user!.email ??"email@gmail.com",
          style: appStyle(14, Colors.grey.shade400, FontWeight.w500),
        ),

        SizedBox(height: 8.h),

        // Location
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.grey.shade500,
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              "Stanford University",
              style: appStyle(12, Colors.grey.shade500, FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}
