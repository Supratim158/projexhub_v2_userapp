import 'package:app/views/home/widgets/trendingnow/trendingnow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app/controllers/project_controller.dart';
import 'package:lottie/lottie.dart';

class TrendingProjectsList extends StatelessWidget {
  const TrendingProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (projectController.topProjectsByCategory.isEmpty) {
        projectController.fetchTopProjectsByCategory();
      }
    });

    return Obx(() {
      final topCategories = projectController.topProjectsByCategory;
      List<Map<String, dynamic>> trendingData = [];

      topCategories.forEach((category, projects) {
        for (var project in projects) {
          trendingData.add({
            "category": category,
            "project": project,
          });
        }
      });

      if (projectController.isLoading && trendingData.isEmpty) {
        return Container(
          height: 250.h,
          child:Center(
        child: Lottie.asset(
        "assets/anime/loading.json",
          height: 100.h,
          width: 100.w,
          fit: BoxFit.cover,
        ),
      ),
        );
      }

      if (trendingData.isEmpty) {
        return const SizedBox();
      }

      return Container(
        height: 280.h,
        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: trendingData.length,
          itemBuilder: (context, index) {
            final data = trendingData[index];
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: TrendingProjectCard(
                category: data["category"],
                project: data["project"],
              ),
            );
          },
        ),
      );
    });
  }
}