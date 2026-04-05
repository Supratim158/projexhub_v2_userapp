import 'package:app/views/entrypoint.dart';
import 'package:app/views/login/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'constants/constants.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Determine initial page at build time, not at global scope
    final box = GetStorage();
    String? token = box.read('token');
    final Widget homePage = (token != null) ? const MainScreen() : LandingPage();

    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF13131A),
                const Color(0xFF13131A),
                const Color(0xFF13131A),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Projex Hub',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: kDark),
              primarySwatch: Colors.grey,
            ),
            home: child,
          ),
        );
      },

      child: homePage,
    );
  }
}