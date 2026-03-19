import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../constants/constants.dart';

import 'widgets/submission_card.dart';

class ProjectStatusPage extends StatefulWidget {
  const ProjectStatusPage({super.key});

  @override
  State<ProjectStatusPage> createState() => _ProjectStatusPageState();
}

class _ProjectStatusPageState extends State<ProjectStatusPage> {
  int selectedTabIndex = 0;
  final List<String> tabs = ["All", "Pending", "Published", "Action Required"];

  // Dummy Data representing various submission states mapped to the enum
  final List<Map<String, dynamic>> submissions = [
    {
      "title": "Quantum Neural Interface v2",
      "date": "Oct 24, 2023",
      "status": SubmissionStatus.pending,
      "image": "assets/images/profile.jpg"
    },
    {
      "title": "Bio-Sync Watch OS",
      "date": "Oct 20, 2023",
      "status": SubmissionStatus.published,
      "image": "assets/images/profile.jpg",
      "views": "1.2k views"
    },
    {
      "title": "Lumina Smart Core",
      "date": "Oct 18, 2023",
      "status": SubmissionStatus.actionRequired,
      "image": "assets/images/profile.jpg",
      "errorMessage": "Missing technical specs"
    },
    {
      "title": "Project Genesis v1",
      "date": "Sep 12, 2023",
      "status": SubmissionStatus.archived,
      "image": "assets/images/profile.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter submissions based on the selected tab
    final filteredSubmissions = submissions.where((sub) {
      if (selectedTabIndex == 0) return true; // "All" tab
      if (selectedTabIndex == 1 && sub["status"] == SubmissionStatus.pending) return true;
      if (selectedTabIndex == 2 && sub["status"] == SubmissionStatus.published) return true;
      if (selectedTabIndex == 3 && sub["status"] == SubmissionStatus.actionRequired) return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: bottomNavBackground,
      body: SafeArea(
        child: CustomContainer(
          color: const Color(0xFF13131A), // Dark aesthetic background
          containerContent: Column(
            children: [
              SizedBox(height: 20.h),
              
              // TOP APP BAR
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                    Text(
                      "My Submissions",
                      style: appStyle(20, Colors.white, FontWeight.bold),
                    ),
                    Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
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
                        return SubmissionCard(project: filteredSubmissions[index]);
                      },
                    ),
              
              SizedBox(height: 80.h), // Padding for Bottom Nav Bar
            ],
          ),
        ),
      ),
    );
  }
}