import 'package:app/models/project_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

import '../../../common/app_style.dart';

class SubmissionCard extends StatelessWidget {
  final ProjectResponse project;
  final VoidCallback onTap;

  const SubmissionCard({super.key, required this.project, required this.onTap,});

  @override
  Widget build(BuildContext context) {

    final status = project.status.toLowerCase();
    
    // Status visual configurations
    Color statusColor;
    String statusText;
    
    switch (status) {
      case "pending":
        statusColor = Colors.amber;
        statusText = "PENDING REVIEW";
        break;
      case "approved":
        statusColor = const Color(0xFF00E676); // Neon green
        statusText = "ACCEPTED";
        break;
      case "rejected":
        statusColor = const Color(0xFFFF3B30); // Bright Red
        statusText = "REJECTED";
        break;
      default:
        statusColor = Colors.grey;
        statusText = status.toUpperCase();
    }

    // Get the first image from the images list
    final String? imageUrl = project.images.isNotEmpty ? project.images[0] : null;

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
              // Image Container
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.black26,
                  boxShadow: status == "rejected"
                      ? [BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade600,
                            size: 30.sp,
                          ),
                        )
                      : Icon(
                          Icons.image,
                          color: Colors.grey.shade600,
                          size: 30.sp,
                        ),
                ),
              ),
              SizedBox(width: 16.w),
              
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        _buildButton(
                          text: "Details",
                          bgColor: const Color(0xFF0F52FF), // Vivid blue
                          textColor: Colors.white,
                          icon: Icons.chevron_right,
                          onTap: onTap,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    
                    // Title
                    Text(
                      project.title,
                      style: appStyle(16, Colors.white, FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    
                    // Submitted Date
                    Text(
                      "Submitted on ${DateFormat('MMM dd, yyyy').format(project.createdAt)}",
                      style: appStyle(12, Colors.grey.shade400, FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     _buildButton(
          //       text: "Details",
          //       bgColor: const Color(0xFF0F52FF), // Vivid blue
          //       textColor: Colors.white,
          //       icon: Icons.chevron_right,
          //       onTap: onTap,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }


  Widget _buildButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
    IconData? icon,
    required VoidCallback onTap, // 👈 ADD THIS
  }) {
    return GestureDetector(
      onTap: onTap, // 👈 HANDLE TAP
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
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
      ),
    );
  }
}
