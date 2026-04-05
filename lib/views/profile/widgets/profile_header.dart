import 'package:app/constants/constants.dart';
import 'package:app/models/login_response.dart';
import 'package:app/views/project/image_gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../common/app_style.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.user});

  final LoginResponse? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Glowing Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    gradient: const SweepGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.purpleAccent,
                        Colors.blueAccent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: user != null && user!.profile.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => ImageGalleryView(
                                  images: [user!.profile],
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: Container(
                              width: 100.r,
                              height: 100.r,
                              color: const Color(0xFF1E1E2E),
                              child: Image.network(
                                user!.profile,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(25.r),
                          child: Container(
                            width: 100.r,
                            height: 100.r,
                            color: const Color(0xFF1E1E2E),
                            child: Icon(Icons.person,
                                size: 50.r, color: Colors.white),
                          ),
                        ),
                ),
                Lottie.asset(
                  "assets/anime/star.json",
                  height: 100.h,
                  width: 100.w,
                  fit: BoxFit.cover,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Name and Verified Badge
            Row(
              children: [
                Text(
                  user!.userName ?? "Username",
                  style: appStyle(20, Colors.white, FontWeight.bold),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.verified,
                  color: Colors.blueAccent,
                  size: 20.sp,
                )
              ],
            ),

            // Subtitle
            Text(
              user!.role ?? "SDE",
              style: appStyle(15, Colors.blueAccent, FontWeight.w600),
            ),

            SizedBox(height: 11.h),
            Text(
              user!.bio ?? "User Bio",
              style: appStyle(14, textGrey, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
