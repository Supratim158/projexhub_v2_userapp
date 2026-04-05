import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/app_style.dart';
import '../../../constants/constants.dart';
import '../../../controllers/project_controller.dart';

class ProjectCategoryList extends StatelessWidget {
  ProjectCategoryList({super.key});

  final List<Map<String, dynamic>> categories = [
    {"title": "All", "icon": Icons.category},
    {"title": "AI", "icon": Icons.psychology},
    {"title": "ML", "icon": Icons.memory},
    {"title": "IoT", "icon": Icons.router},
    {"title": "App", "icon": Icons.phone_android},
    {"title": "Web", "icon": Icons.language},
    {"title": "Blockchain", "icon": Icons.link},
    {"title": "Others", "icon": Icons.devices_other},
  ];

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();

    return Container(
      height: 45.h,
      margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final String title = category["title"] as String;

          return Obx(() {
            final isSelected = projectController.selectedCategory.value == title;

            return GestureDetector(
              onTap: () {
                projectController.selectedCategory.value = title;
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : bottomNavBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade800, width: 0.5.w),
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
                      title,
                      style: appStyle(
                        14,
                        isSelected ? Colors.white : textGrey,
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
