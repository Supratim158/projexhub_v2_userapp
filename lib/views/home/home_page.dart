import 'package:app/common/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../common/heading.dart';
import '../../constants/constants.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/project_controller.dart';
import '../../models/login_response.dart';
import '../profile/login_redirect.dart';
import 'widgets/project_category_list.dart';
import 'widgets/recomendation/recommended_projects_list.dart';
import 'widgets/trendingnow/trending_projects_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final box = GetStorage();

    LoginResponse? user;
    String? token = box.read('token');

    // 🚫 If not logged in
    if (token == null) {
      return const LoginRedirect();
    }

    // ✅ Fetch user from controller
    user = controller.getUserInfo();

    // ⏳ Loader until user loads
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bottomNavBackground,
      body: SafeArea(
        child: CustomContainer(
          onRefresh: () async {
            final projectController = Get.find<ProjectController>();
            await projectController.fetchProjects();
            await projectController.fetchTopProjectsByCategory();
          },
          color: const Color(0xFF13131A),
          containerContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 HEADER
              Container(
                width: double.infinity,
                height: 80.h,
                child: SizedBox(
                  height: 120.h, // ✅ Give fixed height
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/header.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // 🔥 Bottom Fade Gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFF13131A),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ✅ CENTERED CONTENT
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/anime/robo.json",
                                height: 65.h,
                                width: 65.w,
                                fit: BoxFit.cover,
                              ),

                              SizedBox(width: 10.w),

                              // Blue Divider
                              Container(
                                height: 45.h,
                                width: 4.w,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              SizedBox(width: 10.w),

                              // Text Section
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center, // ✅ FIX
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(
                                    text: "ProjexHub",
                                    style: appStyle(
                                      24.sp,
                                      Colors.white,
                                      FontWeight.bold,
                                    ).copyWith(
                                      shadows: [
                                        Shadow(
                                          color: Colors.blueAccent.withOpacity(0.9),
                                          blurRadius: 12,
                                        ),
                                        Shadow(
                                          color: Colors.blueAccent.withOpacity(0.6),
                                          blurRadius: 25,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  ReusableText(
                                    text: "Organize. Track. Showcase",
                                    style: appStyle(
                                      12.sp,
                                      Colors.white,
                                      FontWeight.w600,
                                    ).copyWith(
                                      shadows: [
                                        Shadow(
                                          color: Colors.blueAccent.withOpacity(0.6),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),

              

              // 🔥 TRENDING
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ReusableText(
                  text: "Trending Now",
                  style: appStyle(20, Colors.white, FontWeight.bold),
                ),
              ),

              const TrendingProjectsList(),

              // 🔥 CATEGORY
              ProjectCategoryList(),

              // 🔥 RECOMMENDED
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ReusableText(
                  text: "Recommended For You",
                  style: appStyle(20, Colors.white, FontWeight.bold),
                ),
              ),

              const RecommendedProjectsList(),

              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }
}