import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/constants.dart';

// ✅ Status color function
Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "pending":
      return kSecondary; // orange
    case "approved":
      return kPrimary; // teal
    case "rejected":
      return kRed; // red
    default:
      return kGray;
  }
}

// ✅ Status Badge Widget
Widget buildStatusBadge(String status) {
  final statusColor = getStatusColor(status);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: statusColor.withOpacity(0.3),
      ),
    ),
    child: Text(
      status.toUpperCase(),
      style: TextStyle(
        fontSize: 12.sp,
        color: statusColor,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );
}