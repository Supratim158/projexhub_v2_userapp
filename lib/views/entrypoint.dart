import 'package:app/views/profile/profile_page.dart';
import 'package:app/views/search/search_page.dart';
import 'package:app/views/status/project_status_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../controllers/tab_index_controller.dart';
import 'home/home_page.dart';
import 'uploadProject/project_upload_page.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> pageList = [
    HomePage(),
    SearchProjectsPage(),
    ProjectStatusPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TabIndexController());

    return Obx(() => Scaffold(
      backgroundColor: Colors.transparent,
      // ✅ BODY
      body: pageList[controller.tabIndex],

      // ✅ CENTER FLOATING BUTTON
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          backgroundColor: primaryPurple,
          elevation: 6,
          onPressed: () {
            Get.to(() => ProjectUploadPage());
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      // ✅ BOTTOM NAVIGATION WITH NOTCH
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: bottomNavBackground,
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              // 🔹 HOME
              IconButton(
                icon: controller.tabIndex == 0
                    ? const Icon(AntDesign.appstore1)
                    : const Icon(AntDesign.appstore_o),
                color: controller.tabIndex == 0
                    ? primaryPurple
                    : textGrey,
                onPressed: () {
                  controller.setTabIndex = 0;
                },
              ),

              // 🔹 SEARCH
              IconButton(
                icon: const Icon(AntDesign.search1),
                color: controller.tabIndex == 1
                    ? primaryPurple
                    : textGrey,
                onPressed: () {
                  controller.setTabIndex = 1;
                },
              ),

              const SizedBox(width: 40), // space for FAB

              // 🔹 CART
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                color: controller.tabIndex == 2
                    ? primaryPurple
                    : textGrey,
                onPressed: () {
                  controller.setTabIndex = 2;
                },
              ),

              // 🔹 PROFILE
              IconButton(
                icon: controller.tabIndex == 3
                    ? const Icon(FontAwesome.user_circle)
                    : const Icon(FontAwesome.user_circle_o),
                color: controller.tabIndex == 3
                    ? primaryPurple
                    : textGrey,
                onPressed: () {
                  controller.setTabIndex = 3;
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}