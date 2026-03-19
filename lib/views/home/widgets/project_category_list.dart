import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';
import '../../../constants/constants.dart';

class ProjectCategoryList extends StatelessWidget {
  ProjectCategoryList({super.key});

  final List<Map<String, dynamic>> categories = [
    {"title": "AI", "icon": Icons.psychology, "isSelected": true},
    {"title": "Blockchain", "icon": Icons.link, "isSelected": false},
    {"title": "Web", "icon": Icons.language, "isSelected": false},
    {"title": "Mobile", "icon": Icons.phone_android, "isSelected": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category["isSelected"] as bool;

          return Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : bottomNavBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  category["icon"] as IconData,
                  color: isSelected ? Colors.white : textGrey,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  category["title"] as String,
                  style: appStyle(
                    14,
                    isSelected ? Colors.white : textGrey,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
