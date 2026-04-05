import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:app/views/login/signin_page.dart';
import '../../common/custom_container.dart';
import '../../constants/constants.dart';
import '../login/widgets/animated_button.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bottomNavBackground,

      body: SafeArea(
        child: CustomContainer(
          color: const Color(0xFF13131A), // Dark aesthetic background
          containerContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                Center(
                  child: SizedBox(
                    height: 220,
                    child: Lottie.asset(
                      "assets/anime/robo.json",
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
                SizedBox(height: 30.h,),



                AnimatedButton(
                    text: "LogOut",
                    onTap: (){
                      Get.offAll(() => SigninPage(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 900)
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
