import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../constants/constants.dart';

import 'widgets/search_filter_chips.dart';
import 'widgets/search_result_card.dart';

class SearchProjectsPage extends StatefulWidget {
  const SearchProjectsPage({super.key});

  @override
  State<SearchProjectsPage> createState() => _SearchProjectsPageState();
}

class _SearchProjectsPageState extends State<SearchProjectsPage> {
  String searchQuery = "";

  /// Dummy Data updated to reflect the new UI structure
  final List<Map<String, dynamic>> allProjects = [
    {
      "_id": "1",
      "title": "NeuralNexus V2",
      "description": "AI-driven campus navigation system...",
      "category": "AI",
      "image": "assets/images/profile.jpg"
    },
    {
      "_id": "2",
      "title": "EcoTrack IoT",
      "description": "Real-time electricity monitoring for...",
      "category": "IoT",
      "image": "assets/images/profile.jpg"
    },
    {
      "_id": "3",
      "title": "StudySync Blockchain",
      "description": "Decentralized credential verificatio...",
      "category": "Web",
      "image": "assets/images/profile.jpg"
    },
    {
      "_id": "4",
      "title": "Sentinel Shield",
      "description": "Intrusion detection using deep...",
      "category": "Cyber",
      "image": "assets/images/profile.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final filteredProjects = allProjects.where((project) {
      final title = project['title'].toString().toLowerCase();
      final description = project['description'].toString().toLowerCase();
      final matchesSearch = title.contains(searchQuery.toLowerCase()) ||
          description.contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: bottomNavBackground,
      body: SafeArea(
        child: CustomContainer(
          color: const Color(0xFF13131A), // Dark aesthetic background
          containerContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // TOP APP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.sp),
                    Text(
                      "Explore Projects",
                      style: appStyle(20, Colors.white, FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.person, color: Colors.blueAccent, size: 20.sp),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 30.h),

                // SEARCH INPUT
                Container(
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E), // Dark input background
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Icon(AntDesign.search1, color: Colors.grey.shade400, size: 20.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() => searchQuery = value);
                          },
                          style: appStyle(16, Colors.white, FontWeight.w400),
                          decoration: InputDecoration(
                            hintText: "Search innovative projects...",
                            hintStyle: appStyle(16, Colors.grey.shade500, FontWeight.w400),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Filter Icon Button
                      Container(
                        margin: EdgeInsets.all(8.w),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3D5C), // Dark blueish tint
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(Icons.tune, color: Colors.blueAccent, size: 20.sp),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // FILTER CHIPS
                const SearchFilterChips(),

                SizedBox(height: 30.h),

                // RESULTS HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SEARCH RESULTS",
                      style: appStyle(14, Colors.grey.shade500, FontWeight.bold).copyWith(letterSpacing: 1.2),
                    ),
                    Text(
                      "${filteredProjects.length} Found",
                      style: appStyle(14, Colors.blueAccent, FontWeight.w600),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // RESULTS LIST
                filteredProjects.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Text(
                            "No projects found 😕",
                            style: appStyle(15, Colors.grey, FontWeight.normal),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredProjects.length,
                        itemBuilder: (context, index) {
                          return SearchResultCard(project: filteredProjects[index]);
                        },
                      ),
                      
                SizedBox(height: 80.h), // Bottom nav padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}