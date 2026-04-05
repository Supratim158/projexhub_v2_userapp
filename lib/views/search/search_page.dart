import 'package:app/common/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../constants/constants.dart';

import 'dart:async';
import 'package:get/get.dart';
import '../../controllers/project_controller.dart';
import 'widgets/search_result_card.dart';

class SearchProjectsPage extends StatefulWidget {
  const SearchProjectsPage({super.key});

  @override
  State<SearchProjectsPage> createState() => _SearchProjectsPageState();
}

class _SearchProjectsPageState extends State<SearchProjectsPage> {
  final ProjectController projectController = Get.find<ProjectController>();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isEmpty) {
        projectController.clearSearchResults();
      } else {
        projectController.searchProjects(value.trim());
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchQuery = "";
    });
    projectController.clearSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bottomNavBackground,
      body: SafeArea(
            child: CustomContainer(
              color: const Color(0xFF13131A),
              containerContent: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // TOP APP BAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReusableText(
                          text: "Explore Projects",
                          style: appStyle(20, Colors.white, FontWeight.bold),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // SEARCH INPUT
                    Container(
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2E),
                        borderRadius: BorderRadius.circular(16.r),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          Icon(AntDesign.search1,
                              color: Colors.grey.shade400, size: 20.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              style:
                                  appStyle(16, Colors.white, FontWeight.w400),
                              decoration: InputDecoration(
                                hintText: "Search innovative projects...",
                                hintStyle: appStyle(
                                    16, Colors.grey.shade500, FontWeight.w400),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          // Clear button
                          if (searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: _clearSearch,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Icon(Icons.close,
                                    color: Colors.grey.shade400, size: 20.sp),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // RESULTS HEADER (only show when there's a query)
                    if (searchQuery.isNotEmpty)
                      Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SEARCH RESULTS",
                            style: appStyle(
                                    14, Colors.grey.shade500, FontWeight.bold)
                                .copyWith(letterSpacing: 1.2),
                          ),
                          Text(
                            "${projectController.searchResults.length} Found",
                            style:
                                appStyle(14, Colors.blueAccent, FontWeight.w600),
                          ),
                        ],
                      )),

                    if (searchQuery.isNotEmpty) SizedBox(height: 20.h),

                    // CONTENT AREA (reactive — uses Obx internally)
                    if (searchQuery.isEmpty)
                      _buildEmptyState()
                    else
                      Obx(() => _buildContent()),

                    SizedBox(height: 80.h), // Bottom nav padding
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildContent() {
    // Loading state
    if (projectController.isSearching) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 60.h),
          child: Column(
            children: [
              const CircularProgressIndicator(color: Colors.blueAccent),
              SizedBox(height: 16.h),
              Text(
                "Searching...",
                style: appStyle(14, Colors.grey.shade400, FontWeight.w400),
              ),
            ],
          ),
        ),
      );
    }

    final filteredProjects = projectController.searchResults;

    // No results found
    if (filteredProjects.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded,
                  color: Colors.grey.shade600, size: 60.sp),
              SizedBox(height: 16.h),
              Text(
                "No projects found 😕",
                style: appStyle(16, Colors.grey, FontWeight.w500),
              ),
              SizedBox(height: 8.h),
              Text(
                "Try a different search term",
                style: appStyle(13, Colors.grey.shade600, FontWeight.w400),
              ),
            ],
          ),
        ),
      );
    }

    // Results list
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        return SearchResultCard(project: filteredProjects[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent.withOpacity(0.15)),
              ),
              child: Icon(AntDesign.search1,
                  color: Colors.blueAccent.withOpacity(0.6), size: 40.sp),
            ),
            SizedBox(height: 24.h),
            Text(
              "Search for Projects",
              style: appStyle(18, Colors.white, FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Text(
              "Find amazing projects by name,\ntechnology, or description",
              textAlign: TextAlign.center,
              style: appStyle(14, Colors.grey.shade500, FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
