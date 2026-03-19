import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';

class SearchFilterChips extends StatelessWidget {
  const SearchFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Active (Blue) 'Recent' Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Bright blue
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.history, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  "Recent",
                  style: appStyle(14, Colors.white, FontWeight.bold),
                ),
              ],
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // 'Popular' Dropdown-style Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.grey.shade400, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  "Popular",
                  style: appStyle(14, Colors.grey.shade400, FontWeight.bold),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 18.sp),
              ],
            ),
          ),
          
          SizedBox(width: 12.w),

          // 'Tags' Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A3D),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: Colors.grey.shade400, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  "Tags",
                  style: appStyle(14, Colors.grey.shade400, FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
