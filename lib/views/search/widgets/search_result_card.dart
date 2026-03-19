import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../common/app_style.dart';
import '../../../constants/constants.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const SearchResultCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Generate the right background gradient and tags based on the mock category
    List<Widget> tags = [];
    if (project['category'] == 'AI') {
      tags.addAll([
        _buildTag("AI/ML", Colors.blueAccent.withOpacity(0.2), Colors.blueAccent),
        SizedBox(width: 8.w),
        _buildTag("REACT NATIVE", Colors.grey.withOpacity(0.2), Colors.grey.shade300),
      ]);
    } else if (project['category'] == 'IoT') {
      tags.addAll([
        _buildTag("SUSTAINABILITY", Colors.green.withOpacity(0.2), Colors.green),
        SizedBox(width: 8.w),
        _buildTag("ARDUINO", Colors.grey.withOpacity(0.2), Colors.grey.shade300),
      ]);
    } else if (project['category'] == 'Web') {
      tags.addAll([
        _buildTag("WEB3", Colors.blueAccent.withOpacity(0.2), Colors.blueAccent),
        SizedBox(width: 8.w),
        _buildTag("SOLIDITY", Colors.grey.withOpacity(0.2), Colors.grey.shade300),
      ]);
    } else {
      tags.addAll([
        _buildTag("CYBERSECURITY", Colors.red.withOpacity(0.2), Colors.redAccent),
        SizedBox(width: 8.w),
        _buildTag("PYTHON", Colors.grey.withOpacity(0.2), Colors.grey.shade300),
      ]);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E), // Dark card surface
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock Image Area
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.black26, 
              image: DecorationImage(
                image: AssetImage(project["image"] ?? "assets/images/profile.jpg"), // Using existing profile for mock
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project['title'],
                        style: appStyle(16, Colors.white, FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Ionicons.bookmark,
                      color: project['category'] == 'IoT' ? Colors.blueAccent : Colors.grey.withOpacity(0.7),
                      size: 20.sp,
                    )
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  project['description'],
                  style: appStyle(12, Colors.grey.shade400, FontWeight.w400),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: tags,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: appStyle(10, textColor, FontWeight.bold),
      ),
    );
  }
}
