import 'package:app/models/project_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/app_style.dart';
import '../../../../constants/constants.dart';
import '../../../project/project_details_page.dart';

class RecommendedProjectCard extends StatelessWidget {
  final ProjectResponse myProjects;

  const RecommendedProjectCard({super.key, required this.myProjects});

  @override
  Widget build(BuildContext context) {
    // Get the first image from the images list
    final String? imageUrl = myProjects.images.isNotEmpty ? myProjects.images[0] : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(
              projectId: myProjects.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bottomNavBackground,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 IMAGE SECTION
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      image: imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: imageUrl == null ? Colors.grey.shade800 : null,
                    ),
                    child: imageUrl == null
                        ? Center(
                            child: Icon(Icons.image, color: Colors.grey.shade600, size: 30.sp),
                          )
                        : null,
                  ),

                  /// Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            /// 🔥 DETAILS
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          myProjects.title,
                          style: appStyle(
                              14, Colors.white, FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          myProjects.tagline,
                          style: appStyle(
                            10,
                            Colors.white.withOpacity(0.6),
                            FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.star,
                color: Colors.yellow, size: 12.sp),
            SizedBox(width: 4.w),
            Text(
              myProjects.likeCount.toString(),
              style:
                  appStyle(12, Colors.grey.shade400, FontWeight.w500),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.comment,
                color: Colors.blueAccent, size: 12.sp),
            SizedBox(width: 4.w),
            Text(
              myProjects.comments.length.toString(),
              style:
                  appStyle(12, Colors.grey.shade400, FontWeight.w500),
            ),
          ],
        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}