import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../common/app_style.dart';

class ProfileShowcaseGrid extends StatelessWidget {
  const ProfileShowcaseGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Projects for UI showcase matching the screenshot
    final List<Map<String, dynamic>> projects = [
      {
        "title": "NeuroLink Mobile",
        "tag": "UI DESIGN",
        "likes": "128",
        "views": "1.4k",
        "gradient": const [Color(0xFF8BAA8B), Color(0xFF1B271A)]
      },
      {
        "title": "EcoTrack Dashboard",
        "tag": "FULL STACK",
        "likes": "94",
        "views": "856",
        "gradient": const [Color(0xFFB3B3B3), Color(0xFF333333)]
      },
      {
        "title": "Algorithmic Art Gen",
        "tag": "CREATIVE",
        "likes": "210",
        "views": "2.1k",
        "gradient": const [Color(0xFF2A553B), Color(0xFF0D1C13)]
      },
      {
        "isAddCard": true, // Special empty state for "ADD NEW"
      }
    ];

    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Showcase",
              style: appStyle(20, Colors.white, FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F52FF),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.grid_view, color: Colors.white, size: 18.sp),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.all(6.w),
                  child: Icon(Icons.view_agenda, color: Colors.grey.shade500, size: 18.sp),
                ),
              ],
            )
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Grid
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: projects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.7, // Adjust to make the cards taller
          ),
          itemBuilder: (context, index) {
            final data = projects[index];
            
            if (data["isAddCard"] == true) {
              return _buildAddCard();
            }
            
            return _buildProjectCard(data);
          },
        ),
      ],
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Container
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                colors: data["gradient"] as List<Color>,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    data["tag"],
                    style: appStyle(10, Colors.white, FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Details below image
        Text(
          data["title"],
          style: appStyle(14, Colors.white, FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(AntDesign.like2, color: Colors.grey.shade400, size: 12.sp),
            SizedBox(width: 4.w),
            Text(
              data["likes"],
              style: appStyle(12, Colors.grey.shade400, FontWeight.w500),
            ),
            SizedBox(width: 12.w),
            Icon(AntDesign.eyeo, color: Colors.grey.shade400, size: 12.sp),
            SizedBox(width: 4.w),
            Text(
              data["views"],
              style: appStyle(12, Colors.grey.shade400, FontWeight.w500),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAddCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E), // Matches mock dark blue
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.grey.shade600, size: 40.sp),
          SizedBox(height: 16.h),
          Text(
            "ADD NEW",
            style: appStyle(12, Colors.grey.shade600, FontWeight.bold).copyWith(letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
