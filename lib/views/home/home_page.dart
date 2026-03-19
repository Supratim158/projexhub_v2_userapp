import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../common/heading.dart';
import '../../constants/constants.dart';

import 'widgets/home_search_bar.dart';
import 'widgets/project_category_list.dart';
import 'widgets/recommended_projects_list.dart';
import 'widgets/trending_projects_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bottomNavBackground,
      body: SafeArea(
        child: CustomContainer(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF000000), // Black
              Color(0xFF0C1631), // Deep Blue
              Color(0xFF1A0B2E), // Deep Violet
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
          containerContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage("assets/images/profile.jpg"), // Assuming this asset exists from previous code
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GOOD MORNING",
                              style: appStyle(10, textGrey, FontWeight.w600),
                            ),
                            Text(
                              "Alex Rivers",
                              style: appStyle(16, Colors.white, FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: bottomNavBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // SEARCH BAR
              const HomeSearchBar(),

              // TRENDING NOW
              SizedBox(height: 10.h),
              Heading(
                text: "Trending Now",
                trailing: Text(
                  "View All",
                  style: appStyle(14, Colors.blueAccent, FontWeight.w600),
                ),
                onTap: () {},
              ),
              
              const TrendingProjectsList(),

              // CATEGORIES
              ProjectCategoryList(),

              // RECOMMENDED FOR YOU
              Heading(
                text: "Recommended For You",
                trailing: Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 20.sp,
                ),
                onTap: () {},
              ),
              
              const RecommendedProjectsList(),

              // Padding for bottom nav
              SizedBox(height: 80.h), 
            ],
          ),
        ),
      ),
    );
  }
}
