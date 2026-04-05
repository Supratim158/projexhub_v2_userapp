
import 'package:app/models/project_response.dart';
import 'package:app/views/login/signin_page.dart';
import 'package:app/views/project/project_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../constants/constants.dart';

import '../../controllers/project_controller.dart';
import 'widgets/submission_card.dart';

class ProjectStatusPage extends StatefulWidget {
  const ProjectStatusPage({super.key});

  @override
  State<ProjectStatusPage> createState() => _ProjectStatusPageState();
}

class _ProjectStatusPageState extends State<ProjectStatusPage> {
  int selectedTabIndex = 0;
  final List<String> tabs = ["All", "Pending", "Published", "Action Required"];
  final ProjectController projectController = Get.find<ProjectController>();

  @override
  void initState() {
    super.initState();
    // Fetch ONCE when page initializes instead of every build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      projectController.fetchMyProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');

    if (token == null) {
      return SigninPage();
    }

    return Scaffold(
      backgroundColor: bottomNavBackground,
      body: Obx(() {
        // Evaluate reactive variables INSIDE Obx so it tracks changes
        final projects = projectController.userProjects;

        // Filter submissions based on the selected tab
        final filteredSubmissions = projects.where((sub) {
          if (selectedTabIndex == 0) return true; // "All" tab
          if (selectedTabIndex == 1 && sub.status == "pending") return true;
          if (selectedTabIndex == 2 && sub.status == "approved") return true;
          if (selectedTabIndex == 3 && sub.status == "rejected") return true;
          return false;
        }).toList();

        // 🔥 Loading state
        if (projectController.isLoading && projects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: CustomContainer(
            color: const Color(0xFF13131A), // Dark aesthetic background
            containerContent: Column(
              children: [
                SizedBox(height: 20.h),

                // TOP APP BAR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "My Submissions",
                        style: appStyle(20, Colors.white, FontWeight.bold),
                      ),
                      // Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // SLIDING TAB LAYOUT
                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedTabIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tabs[index],
                                style: appStyle(
                                  16,
                                  isSelected ? Colors.white : Colors.grey.shade500,
                                  isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  margin: EdgeInsets.only(top: 8.h),
                                  height: 3.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F52FF), // Vivid blue underline
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Divider
                Divider(color: Colors.white.withOpacity(0.05), height: 1),

                SizedBox(height: 20.h),

                // LIST OF SUBMISSIONS
                filteredSubmissions.isEmpty
                    ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Text(
                      "No submissions found in this category.",
                      style: appStyle(14, Colors.grey, FontWeight.normal),
                    ),
                  ),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: filteredSubmissions.length,
                  itemBuilder: (context, index) {
                    final project = filteredSubmissions[index];
                    return SubmissionCard(project: project, onTap: () {
                      Get.to(() => ProjectDetailsPage(projectId: project.id));
                    },);
                  },
                ),

                SizedBox(height: 80.h), // Padding for Bottom Nav Bar
              ],
            ),
          ),
        );
      })
    );
  }
}