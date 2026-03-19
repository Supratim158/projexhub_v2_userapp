import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../common/app_style.dart';

enum SubmissionStatus { pending, published, actionRequired, archived }

class SubmissionCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const SubmissionCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final status = project['status'] as SubmissionStatus;
    
    // Status visual configurations
    Color statusColor;
    String statusText;
    
    switch (status) {
      case SubmissionStatus.pending:
        statusColor = Colors.amber;
        statusText = "PENDING REVIEW";
        break;
      case SubmissionStatus.published:
        statusColor = const Color(0xFF00E676); // Neon green
        statusText = "PUBLISHED";
        break;
      case SubmissionStatus.actionRequired:
        statusColor = const Color(0xFFFF3B30); // Bright Red
        statusText = "ACTION REQUIRED";
        break;
      case SubmissionStatus.archived:
        statusColor = Colors.grey.shade500;
        statusText = "ARCHIVED";
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E), // Dark card surface
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container (Mock)
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.black26,
                  image: DecorationImage(
                    image: AssetImage(project["image"] ?? "assets/images/profile.jpg"),
                    fit: BoxFit.cover,
                    // Grayscale filter for archived
                    colorFilter: status == SubmissionStatus.archived
                        ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                        : ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                  ),
                  boxShadow: status == SubmissionStatus.actionRequired
                      ? [BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)]
                      : null,
                ),
              ),
              SizedBox(width: 16.w),
              
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        statusText,
                        style: appStyle(10, statusColor, FontWeight.w800).copyWith(letterSpacing: 0.5),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    
                    // Title
                    Text(
                      project['title'],
                      style: appStyle(16, Colors.white, FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    
                    // Submitted Date
                    Text(
                      "Submitted on ${project['date']}",
                      style: appStyle(12, Colors.grey.shade400, FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Bottom Actions Row based on Status
          _buildBottomActionRow(status, project),
        ],
      ),
    );
  }

  Widget _buildBottomActionRow(SubmissionStatus status, Map<String, dynamic> project) {
    switch (status) {
      case SubmissionStatus.pending:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAvatarGroup(),
            _buildButton(
              text: "Track Details",
              bgColor: const Color(0xFF0F52FF), // Vivid blue
              textColor: Colors.white,
              icon: Icons.chevron_right,
            ),
          ],
        );
      case SubmissionStatus.published:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(AntDesign.eyeo, color: const Color(0xFF00E676), size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  project['views'] ?? "0 views",
                  style: appStyle(12, const Color(0xFF00E676), FontWeight.w500),
                )
              ],
            ),
            _buildButton(
              text: "View Project",
              bgColor: Colors.transparent,
              textColor: Colors.white,
              borderColor: Colors.grey.shade600,
            ),
          ],
        );
      case SubmissionStatus.actionRequired:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: const Color(0xFFFF3B30), size: 14.sp),
                SizedBox(width: 6.w),
                Text(
                  project['errorMessage'] ?? "Action needed",
                  style: appStyle(12, const Color(0xFFFF3B30), FontWeight.normal).copyWith(fontStyle: FontStyle.italic),
                )
              ],
            ),
            _buildButton(
              text: "Resolve Now",
              bgColor: const Color(0xFFFF3B30),
              textColor: Colors.white,
            ),
          ],
        );
      case SubmissionStatus.archived:
        return const SizedBox.shrink(); // No bottom action for archived
    }
  }

  Widget _buildButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: appStyle(14, textColor, FontWeight.bold),
          ),
          if (icon != null) ...[
            SizedBox(width: 4.w),
            Icon(icon, color: textColor, size: 18.sp),
          ]
        ],
      ),
    );
  }

  Widget _buildAvatarGroup() {
    return SizedBox(
      width: 50.w,
      height: 24.w,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: Colors.grey.shade700,
              child: Text("JD", style: appStyle(10, Colors.white, FontWeight.bold)),
            ),
          ),
          Positioned(
            left: 16.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E1E2E), // Background mask
              ),
              child: CircleAvatar(
                radius: 10.r,
                backgroundColor: const Color(0xFF0F52FF),
                child: Text("AI", style: appStyle(8, Colors.white, FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
