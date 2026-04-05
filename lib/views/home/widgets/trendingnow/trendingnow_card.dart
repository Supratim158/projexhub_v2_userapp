import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/app_style.dart';
import '../../../project/project_details_page.dart';
import 'package:app/models/project_response.dart';

class TrendingProjectCard extends StatelessWidget {
  final String category;
  final ProjectResponse project;

  const TrendingProjectCard({super.key, required this.category, required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(
              projectId: project.id,
            ),
          ),
        );
      },
      child: Container(
        width: 300.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: NetworkImage(
              project.images.isNotEmpty 
                  ? project.images.first 
                  : "https://images.unsplash.com/photo-1639322537228-f710d846310a"
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(16.r),
  border: Border.all(color: Colors.grey.shade800, width: 0.5.w),
  gradient: LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Colors.black, // strong at bottom
      Colors.black.withOpacity(0.9),
      Colors.transparent, // fades upward
    ],
  ),
),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                /// 🔥 TAG
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    category,
                    style: appStyle(10, Colors.white, FontWeight.bold),
                  ),
                ),

                SizedBox(height: 8.h),

                /// 🔥 TITLE
                Text(
                  project.title,
                  style: appStyle(18, Colors.white, FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                /// 🔥 SUBTITLE
                Text(
                  project.tagline,
                  style: appStyle(
                    12,
                    Colors.white.withOpacity(0.85),
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
                color: Colors.yellow, size: 20.sp),
            SizedBox(width: 4.w),
            Text(
              project.likeCount.toString(),
              style:
                  appStyle(15, Colors.grey.shade400, FontWeight.w500),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.comment,
                color: Colors.blueAccent, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              project.comments.length.toString(),
              style:
                  appStyle(15, Colors.grey.shade400, FontWeight.w500),
            ),
          ],
        )

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 👇 Avatar Stack
  Widget _buildAvatarStack() {
    return SizedBox(
      width: 50.w,
      height: 20.w,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.grey,
            ),
          ),
          Positioned(
            left: 12.w,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.blue,
            ),
          ),
          Positioned(
            left: 24.w,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}