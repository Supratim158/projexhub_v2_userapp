import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';
import '../../../constants/constants.dart';
import '../../project/project_details_page.dart';

class RecommendedProjectsList extends StatelessWidget {
  const RecommendedProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.75, // Adjust for card height
        ),
        itemBuilder: (context, index) {
          return _buildRecommendedCard(context, index);
        },
      ),
    );
  }

  Widget _buildRecommendedCard(BuildContext context, int index) {
    // Mock data for variation
    final List<Map<String, dynamic>> mockData = [
      {
        "title": "EcoHome IoT",
        "subtitle": "Smart energy monitoring system.",
        "rating": "4.9",
        "views": "2.1k",
        "gradient": const [Color(0xFF5A8973), Color(0xFF1B2A27)],
      },
      {
        "title": "Sentinel Shield",
        "subtitle": "AI-driven firewall for SMBs.",
        "rating": "4.7",
        "views": "1.8k",
        "gradient": const [Color(0xFFD4C9A8), Color(0xFF2A2820)],
      },
      {
        "title": "DataFlow Pro",
        "subtitle": "Real-time data stream analytics.",
        "rating": "5.0",
        "views": "892",
        "gradient": const [Color(0xFFA1C1A6), Color(0xFF1E2822)],
      },
      {
        "title": "VitalSync",
        "subtitle": "Wearable tech for cardiac health.",
        "rating": "4.8",
        "views": "3.4k",
        "gradient": const [Color(0xFFB3C1B3), Color(0xFF222A26)],
      },
    ];

    final data = mockData[index % mockData.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(
              projectData: data,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bottomNavBackground, // fallback
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top half image gradient
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                    gradient: LinearGradient(
                      colors: data["gradient"] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // Bottom half details
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["title"],
                            style: appStyle(14, Colors.white, FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            data["subtitle"],
                            style: appStyle(10, Colors.white.withOpacity(0.6), FontWeight.w400),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 12.sp),
                              SizedBox(width: 4.w),
                              Text(
                                data["rating"],
                                style: appStyle(10, Colors.white, FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "${data['views']} views",
                            style: appStyle(10, Colors.white.withOpacity(0.5), FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Favorite Button (Heart)
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
