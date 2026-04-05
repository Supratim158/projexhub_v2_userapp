import 'package:app/common/app_style.dart';
import 'package:app/common/custom_container.dart';
import 'package:app/common/reusable_text.dart';
import 'package:app/constants/constants.dart';
import 'package:app/views/profile/widgets/profile_action_buttons.dart';
import 'package:app/views/settings/widgets/account_card.dart';
import 'package:app/views/settings/widgets/app_info_card.dart';
import 'package:app/views/settings/widgets/faq_bottom_sheet.dart';
import 'package:app/views/settings/widgets/feedback_card.dart';
import 'package:app/views/settings/widgets/password_bottom_sheet.dart';
import 'package:app/views/settings/widgets/privaccy_policy_card.dart';
import 'package:app/views/settings/widgets/support_card.dart';
import 'package:app/views/settings/widgets/theme_bottom_sheet.dart';
import 'package:app/views/settings/widgets/tnc_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF13131A),
        appBar: PreferredSize(
  preferredSize: Size.fromHeight(70.h),
  child: Padding(
    padding: EdgeInsets.only(top: 20.h, bottom: 10.h, left: 10.w, right: 10.w),
    child: Row(
      children: [
        // 🔙 Back Button
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),

        // 📌 Center Title
        Expanded(
          child: Center(
            child: ReusableText(
              text: "Settings",
              style: appStyle(20, Colors.white, FontWeight.bold),
            ),
          ),
        ),

        // 👇 To balance center alignment
        SizedBox(width: 48.w),
      ],
    ),
  ),
),
        body: CustomContainer(
            color: const Color(0xFF13131A),
            containerContent: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      ReusableText(
                        text: "Account Settings",
                        style: appStyle(15, Colors.white, FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 165.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        AccountCard(
                          title: "Profile Information",
                          subtitle: 'Manage your profile information',
                          icon: Icons.person,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // full height control
                                backgroundColor: Colors.transparent, // important for custom UI
                                builder: (context) {
                                  return DraggableScrollableSheet(
                                    initialChildSize: 0.2, // default height (70%)
                                    minChildSize: 0.2,
                                    maxChildSize: 0.95,
                                    expand: false,
                                    builder: (context, scrollController) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: bottomNavBackground, // 👈 background color
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            // 🔹 Drag Handle
                                            SizedBox(height: 30),
                                            Container(
                                              height: 5,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            // 🔹 Content
                                            Expanded(
                                              child: SingleChildScrollView(
                                                controller: scrollController,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: ProfileActionButtons(),
                                                ), // 👈 your page
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }, 
                        ),
                        SizedBox(height: 5.h,),
                        const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ),
                        SizedBox(height: 5.h,),
                        AccountCard(
                          title: "Password & Security",
                          subtitle: 'Manage your password and security',
                          icon: Icons.lock,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return const PasswordBottomSheet();
                              },
                            );
                          }, 
                        ),

                        
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  Row(
                    children: [
                      ReusableText(
                        text: "App Theme",
                        style: appStyle(15, Colors.white, FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 86.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        AccountCard(
                          title: "Profile Theme",
                          subtitle: 'Manage your profile theme',
                          icon: Icons.person,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return ThemeBottomSheet(
                                  selectedTheme: "system", // 👈 store this in state
                                  onThemeChanged: (value) {
                                    print("Selected Theme: $value");

                                    // 👉 TODO: Apply theme globally
                                  },
                                );
                              },
                            );
                          }, 
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  Row(
                    children: [
                      ReusableText(
                        text: "App Support",
                        style: appStyle(15, Colors.white, FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 390.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        SupportCard(
                          title: "FAQs",
                          icon: Icons.help,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true, 
                              backgroundColor: Colors.transparent,
                              builder: (context) => FAQBottomSheet(),
                            );
                          }, 
                        ),
                        SizedBox(height: 5.h,),
                        const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ),
                        SizedBox(height: 5.h,),
                        SupportCard(
                          title: "Send Feedback",
                          icon: Icons.feedback,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return const FeedbackBottomSheet();
                              },
                            );
                          }, 
                        ),
                        SizedBox(height: 5.h,),
                        const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ),
                        SizedBox(height: 5.h,),
                        SupportCard(
                          title: "Privacy Policy",
                          icon: Icons.policy,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              isDismissible: true, // tap outside to close
                              enableDrag: true,
                              builder: (context) => PrivacyPolicyBottomSheet(),
                            );
                          }, 
                        ),
                        SizedBox(height: 5.h,),
                        const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ),
                        SizedBox(height: 5.h,),
                        SupportCard(
                          title: "Terms of Service",
                          icon: Icons.policy,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              isDismissible: true, // tap outside to close
                              enableDrag: true,
                              builder: (context) => TermsAndConditionsBottomSheet(),
                            );
                          }, 
                        ),

                        SizedBox(height: 5.h,),
                        const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ),
                        SizedBox(height: 5.h,),
                        SupportCard(
                          title: "Updates",
                          icon: Icons.update,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Update"),
                                  content: Text("No updates available"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, 
                        ),

                        

                        
                      ],
                    ),
                  ),
                
                  SizedBox(height: 20.h,),
                  Row(
                    children: [
                      ReusableText(
                        text: "App Info",
                        style: appStyle(15, Colors.white, FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                          child: const Divider(
                        color: textGrey,
                        thickness: 0.5,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    height: 86.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        SupportCard(
                          title: "App Version",
                          icon: Icons.info,
                          onTap: () {
                            showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) => AppInfoBottomSheet(),
  );
                          }, 
                        ),

                        
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Center(
  child: Text(
    "© 2026 ProjexHub. All rights reserved.\nBuilt with ❤️ by the ProjexHub Team",
    style: appStyle(12, Colors.white.withOpacity(0.8), FontWeight.w500),
    textAlign: TextAlign.center,
  ),
),
                  SizedBox(height: 30.h,),
                ],
              ),
            )),
      ),
    );
  }
}
