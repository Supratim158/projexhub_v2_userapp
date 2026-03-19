import 'package:app/views/entrypoint.dart';
import 'package:app/views/login/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'constants/constants.dart';

// Widget defaultHomePage = MainScreen();
Widget defaultHomePage = LandingPage();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 825),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kDark,
                kDark,
                kDark,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Food Delivery',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: kDark),
              primarySwatch: Colors.grey,
            ),
            home: child,
          ),
        );
      },

      child: defaultHomePage,
    );
  }
}