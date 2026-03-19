import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';

class AchievementBadges extends StatelessWidget {
  const AchievementBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ACHIEVEMENT BADGES",
          style: appStyle(12, Colors.grey.shade500, FontWeight.bold).copyWith(letterSpacing: 2),
        ),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildBadge(Icons.emoji_events, Colors.amber, hasNotification: true, notificationCount: "3"),
              SizedBox(width: 16.w),
              _buildBadge(Icons.auto_awesome, Colors.lightBlueAccent, hasNotification: false),
              SizedBox(width: 16.w),
              _buildBadge(Icons.rocket_launch, Colors.greenAccent, hasNotification: false),
              SizedBox(width: 16.w),
              _buildBadge(Icons.favorite, Colors.pinkAccent, hasNotification: false),
              SizedBox(width: 16.w),
              _buildBadge(Icons.bolt, Colors.purpleAccent, hasNotification: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, Color iconColor, {required bool hasNotification, String? notificationCount}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 55.w,
          height: 55.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1E1E2E), // Dark badge background
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 26.sp,
          ),
        ),
        
        if (hasNotification)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0F52FF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF13131A), width: 2), // Background mask
              ),
              child: Text(
                notificationCount ?? "",
                style: appStyle(10, Colors.white, FontWeight.bold),
              ),
            ),
          )
      ],
    );
  }
}
