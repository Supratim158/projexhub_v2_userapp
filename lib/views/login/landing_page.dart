import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../common/app_style.dart';
import '../../common/bg_controller.dart';
import '../../common/reusable_text.dart';
import 'signin_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BgController(
        color: const Color(0xFF0F0C29),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🔹 Lottie Animation
              SizedBox(
                height: 220,
                child: Lottie.asset(
                  "assets/anime/robo.json",
                  repeat: true,
                  animate: true,
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 App Logo
               /// 🔹 App Logo
              Hero(
                tag: 'logo',
                child: Material(
                  color: Colors.transparent,
                  child: ReusableText(
                    text: "ProjexHub",
                    style: appStyle(
                      40.sp,
                      Colors.white,
                      FontWeight.bold,
                    ).copyWith(
                      shadows: [
                        Shadow(
                          color: Colors.blueAccent.withOpacity(0.9),
                          blurRadius: 12,
                        ),
                        Shadow(
                          color: Colors.blueAccent.withOpacity(0.6),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 Subtitle
              ReusableText(
                text: "Organize. Track. Showcase",
                style: appStyle(
                  15.sp,
                  Colors.white,
                  FontWeight.w600,
                ).copyWith(
                  shadows: [
                    Shadow(
                      color: Colors.blueAccent.withOpacity(0.6),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              /// 🔹 Explore Button Animation
              ScaleTransition(
                scale: _pulse,
                child: GestureDetector(
                  onTap: () {
    Get.to(() => SigninPage(),
    transition: Transition.fade,
    duration: Duration(milliseconds: 500));
    },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.purpleAccent
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Text(
                      "EXPLORE NOW",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}