import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/app_style.dart';
import '../../../models/search_response.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../project/project_details_page.dart';
import '../../project/widgets/status_badge.dart';

class SearchResultCard extends StatelessWidget {
  final SearchResponse project;

  const SearchResultCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() => ProjectDetailsPage(projectId: project.id));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Image
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.black26,
                  image: DecorationImage(
                    image: (project.image.isNotEmpty)
                        ? NetworkImage(project.image) as ImageProvider
                        : const AssetImage("assets/images/profile.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.darken),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: appStyle(16, Colors.white, FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      project.description,
                      style:
                          appStyle(12, Colors.grey.shade400, FontWeight.w400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(project.createdAt),
                          style: appStyle(
                              12, Colors.grey.shade400, FontWeight.w400),
                        ),
                        buildStatusBadge(project.status),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Relevance score indicator
                    if (project.score > 0)
                      Row(
                        children: [
                          Icon(Icons.trending_up,
                              color: Colors.greenAccent, size: 14.sp),
                          SizedBox(width: 6.w),
                          Text(
                            "${(project.score * 100).toStringAsFixed(0)}% match",
                            style: appStyle(
                                11, Colors.greenAccent, FontWeight.w600),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
