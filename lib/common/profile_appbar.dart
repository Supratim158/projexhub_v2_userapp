import 'package:app/common/reusable_text.dart';
import 'package:app/constants/constants.dart';
import 'package:app/views/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_style.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF13131A), // Dark aesthetic background
      elevation: 0,
      
      title: ReusableText(
        text: "CREATOR PROFILE", 
        style: appStyle(16, Colors.white, FontWeight.bold).copyWith(letterSpacing: 1.5),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(() => const SettingsPage());
          },
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.settings, color: Colors.white, size: 24.sp),
          ),
        )
      ],
    );
  }
}
