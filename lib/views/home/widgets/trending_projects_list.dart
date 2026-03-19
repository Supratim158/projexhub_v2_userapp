import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';
import '../../../constants/constants.dart';

class TrendingProjectsList extends StatelessWidget {
  const TrendingProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          _buildTrendingCard(
            title: "NeuroLink Vision",
            subtitle: "Real-time object detection for visually impaired.",
            tag: "AI & ETHICS",
            tagColor: Colors.blueAccent,
            gradientColors: [Color(0xFF8BAA8B), Color(0xFF1B271A)],
            contributors: 12,
          ),
          SizedBox(width: 16.w),
          _buildTrendingCard(
            title: "EtherSafe API",
            subtitle: "Decentralized authenticator framework for Web3.",
            tag: "WEB 3",
            tagColor: Colors.tealAccent.shade400,
            gradientColors: [Color(0xFFB3B3B3), Color(0xFF333333)],
            contributors: 5,
          ),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }

  Widget _buildTrendingCard({
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required List<Color> gradientColors,
    required int contributors,
  }) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                tag,
                style: appStyle(10, Colors.white, FontWeight.bold),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: appStyle(18, Colors.white, FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: appStyle(12, Colors.white.withOpacity(0.8), FontWeight.w400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildAvatarStack(),
                SizedBox(width: 8.w),
                Text(
                  "+$contributors Contributors",
                  style: appStyle(10, Colors.white.withOpacity(0.7), FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      width: 40.w,
      height: 20.w,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.grey,
            ),
          ),
          Positioned(
            left: 12.w,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
