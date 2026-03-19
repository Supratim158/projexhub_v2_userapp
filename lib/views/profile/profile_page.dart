import 'package:app/controllers/login_controller.dart';
import 'package:app/models/login_response.dart';
import 'package:app/views/login/widgets/animated_button.dart';
import 'package:app/views/profile/login_redirect.dart';
import 'package:app/views/profile/widgets/achievement_badges.dart';
import 'package:app/views/profile/widgets/profile_action_buttons.dart';
import 'package:app/views/profile/widgets/profile_header.dart';
import 'package:app/views/profile/widgets/profile_showcase_grid.dart';
import 'package:app/views/profile/widgets/profile_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../common/custom_container.dart';
import '../../common/profile_appbar.dart';
import '../../constants/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    LoginResponse? user;

    final box = GetStorage();

    String? token = box.read('token');

    if(token != null){
      user = controller.getUserInfo();
    }
    
    if(token == null){
      return LoginRedirect();
    }
    return Scaffold(
      backgroundColor: bottomNavBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: const ProfileAppbar(),
      ),
      body: SafeArea(
        child: CustomContainer(
          color: const Color(0xFF13131A), // Dark aesthetic background
          containerContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                
                // 1. User Avatar, Name, Title, Location
                ProfileHeader(user: user,),
                
                SizedBox(height: 24.h),
                
                // 2. Stats Row (Projects, Followers, Stars)
                const ProfileStats(),

                SizedBox(height: 24.h),
                
                // 3. Action Buttons (Edit Profile, Share)
                const ProfileActionButtons(),

                SizedBox(height: 32.h),

                // 4. Achievement Badges 
                const AchievementBadges(),

                SizedBox(height: 32.h),

                // 5. Showcase Projects Grid
                const ProfileShowcaseGrid(),

                // Bottom Padding for Nav Bar
                SizedBox(height: 80.h),

                AnimatedButton(
                    text: "LogOut",
                    onTap: (){
                      controller.logout();
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
