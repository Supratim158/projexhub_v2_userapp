import 'package:app/controllers/project_controller.dart';
import 'package:app/views/home/widgets/recomendation/recomendation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RecommendedProjectsList extends StatelessWidget {
  const RecommendedProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (projectController.myProjects.isEmpty) {
        projectController.fetchProjects();
      }
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Obx(() {
        final projects = projectController.filteredProjects;

        if (projectController.isLoading && projects.isEmpty) {
          return Center(
              child: Lottie.asset(
                "assets/anime/loading.json",
                height: 100.h,
                width: 100.w,
                fit: BoxFit.cover,
              ),
          );
        }

        if (projects.isEmpty) {
          return Center(
            child: Text(
              "No projects found.",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
          );
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: projects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return RecommendedProjectCard(
              myProjects: projects[index],
            );
          },
        );
      }),
    );
  }
}