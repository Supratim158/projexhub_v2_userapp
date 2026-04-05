import 'package:app/common/app_style.dart';
import 'package:app/common/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../controllers/ai_controller.dart';

class AIAnalyzerPage extends StatelessWidget {
  final String projectId;

  AIAnalyzerPage({super.key, required this.projectId});

  final AIController controller = Get.put(AIController());
  final TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Column(
          children: [

            
      
            // 🔥 HEADER
                Container(
                  width: double.infinity,
                  height: 70.h,
                  child: Stack(
                    children: [

                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage("assets/images/header.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
      
                      // 🔥 Bottom Fade Gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFF000000), // match your app background
                              ],
                            ),
                          ),
                        ),
                      ),
      
                      // Content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25.sp)),
                              
                            Lottie.asset(
                              "assets/anime/Live chatbot.json",
                              height: 70.h,
                              width: 70.w,
                              fit: BoxFit.cover,
                            ),

                            SizedBox(width: 15.w),
      
      
                            Container(
                              height: 30.h,
                              width: 5.w,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
      
                            SizedBox(width: 5.w),
      
                            ReusableText(
                              text: "ProjexHub AI",
                              style: appStyle(
                                25.sp,
                                Colors.white,
                                FontWeight.bold,
                              ).copyWith(
                                shadows: [
                                  Shadow(
                                    color: Colors.blueAccent.withOpacity(0.9),
                                    blurRadius: 12,
                                    offset: Offset(0, 0),
                                  ),
                                  Shadow(
                                    color: Colors.blueAccent.withOpacity(0.6),
                                    blurRadius: 25,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            
            SizedBox(height: 20),
        
            
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E), // Dark input background
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    Icon(AntDesign.search1,
                        color: Colors.grey.shade400, size: 20.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextField(
                        controller: questionController,
                        style: appStyle(16, Colors.white, FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: "Ask anything about this project...",
                          hintStyle:
                              appStyle(16, Colors.grey.shade500, FontWeight.w400),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: GestureDetector(
                onTap: () {
                  controller.askQuestion(
                    projectId,
                    questionController.text,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C64F2),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Center(
                      child: ReusableText(
                        text: "Ask AI",
                        style: appStyle(12, Colors.white.withOpacity(0.7),
                                FontWeight.normal)
                            .copyWith(height: 1.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        
            SizedBox(height: 10),
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.getSummary(projectId);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C64F2),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Center(
                          child: ReusableText(
                            text: "Project Summary",
                            style: appStyle(12, Colors.white.withOpacity(0.7),
                                    FontWeight.normal)
                                .copyWith(height: 1.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.getScore(projectId);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C64F2),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Center(
                          child: ReusableText(
                            text: "Project Score",
                            style: appStyle(12, Colors.white.withOpacity(0.7),
                                    FontWeight.normal)
                                .copyWith(height: 1.6),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        
            SizedBox(height: 7),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const Divider(color: Colors.white),
            ),
            SizedBox(height: 7),
            ReusableText(
                            text: "Result",
                            style: appStyle(14, Colors.white.withOpacity(0.7),
                                    FontWeight.normal)),
        
            SizedBox(height: 5),
        
            // 🔹 RESULT
            Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                  child: Lottie.asset(
                    "assets/anime/star.json",
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
              );
            }
        
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                      color: const Color(0xFF151722),
                      borderRadius: BorderRadius.circular(16.r),
                ),
                child: SingleChildScrollView(
                      child: Text(
                        controller.result.value.isEmpty
                ? "Your AI result will appear here..."
                : controller.result.value,
                        style: appStyle(
              14,
              Colors.white.withOpacity(0.7),
              FontWeight.normal,
                        ).copyWith(height: 1.6),
                      ),
                ),
              ),
            );
          }),
        )
          ],
        ),
      ),
    );
  }


}
