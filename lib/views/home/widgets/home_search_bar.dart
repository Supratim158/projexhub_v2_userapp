import 'package:app/common/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../constants/constants.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      height: 50.h,
      decoration: BoxDecoration(
        color: bottomNavBackground, // Using a dark background resembling the search bar
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(
            AntDesign.search1,
            color: textGrey,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              style: appStyle(14, textWhite, FontWeight.w400),
              decoration: InputDecoration(
                hintText: "Search innovative projects...",
                hintStyle: appStyle(14, textGrey, FontWeight.w400),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
