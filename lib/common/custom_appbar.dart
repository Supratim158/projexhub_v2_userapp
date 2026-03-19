import 'package:app/common/reusable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';
import 'app_style.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 90.h,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4B2FA3),
            Color(0xFF2A1E63),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// LEFT MENU BUTTON
            Align(
              alignment: Alignment.centerLeft,
              child: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            /// CENTER TITLE
            ReusableText(
              text: "ProjexHub",
              style: appStyle(20, Colors.white, FontWeight.bold),
            ),

            /// RIGHT SETTINGS BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.settings_solid,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}