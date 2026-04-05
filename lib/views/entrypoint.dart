import 'package:app/views/profile/profile_page.dart';
import 'package:app/views/search/search_page.dart';
import 'package:app/views/status/project_status_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../controllers/login_controller.dart';
import '../controllers/project_controller.dart';
import '../controllers/tab_index_controller.dart';
import 'home/home_page.dart';
import 'uploadProject/project_upload_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pageList = [
    const HomePage(),
    SearchProjectsPage(),
    const ProjectStatusPage(),
    const ProfilePage(),
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // ✅ Register all controllers once at the top level
    Get.put(LoginController(), permanent: true);
    final projectController = Get.put(ProjectController(), permanent: true);
    final tabController = Get.put(TabIndexController(), permanent: true);

    _pageController = PageController(initialPage: tabController.tabIndex);

    // ✅ Fetch initial data on cold start so pages aren't blank
    projectController.fetchProjects();
    projectController.fetchTopProjectsByCategory();
    projectController.fetchMyProjects();
    projectController.fetchApprovedUserProjects();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index, TabIndexController controller) {
    controller.setTabIndex = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TabIndexController>();

    return Obx(() => Scaffold(
      backgroundColor: Colors.transparent,
      // ✅ BODY
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          controller.setTabIndex = index;
        },
        children: pageList,
      ),

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
                onPressed: () => _onTabTapped(0, controller),
              ),

              // 🔹 SEARCH
              IconButton(
                icon: const Icon(AntDesign.search1),
                color: controller.tabIndex == 1
                    ? primaryPurple
                    : textGrey,
                onPressed: () => _onTabTapped(1, controller),
              ),

              const SizedBox(width: 40), // space for FAB

              // 🔹 CART
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                color: controller.tabIndex == 2
                    ? primaryPurple
                    : textGrey,
                onPressed: () => _onTabTapped(2, controller),
              ),

              // 🔹 PROFILE
              IconButton(
                icon: controller.tabIndex == 3
                    ? const Icon(FontAwesome.user_circle)
                    : const Icon(FontAwesome.user_circle_o),
                color: controller.tabIndex == 3
                    ? primaryPurple
                    : textGrey,
                onPressed: () => _onTabTapped(3, controller),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}