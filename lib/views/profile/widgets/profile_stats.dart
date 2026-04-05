import 'package:app/controllers/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_style.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Obx(() => _buildStatCard(
            projectController.approvedUserProjects.length.toString(), 
            "PROJECTS POSTED"
          )),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: appStyle(18, Colors.white, FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: appStyle(10, Colors.grey.shade500, FontWeight.bold)
                .copyWith(letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}
