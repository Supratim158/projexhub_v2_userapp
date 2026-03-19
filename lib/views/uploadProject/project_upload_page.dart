import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../constants/constants.dart';
import '../../controllers/project_upload_controller.dart';

class ProjectUploadPage extends StatelessWidget {
  ProjectUploadPage({Key? key}) : super(key: key);

  final ProjectUploadController controller = Get.put(ProjectUploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload Project",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Obx(() => IconButton(
          icon: Icon(
            controller.currentStep.value == 0 ? Icons.close : Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20.sp,
          ),
          onPressed: () {
            if (controller.currentStep.value == 0) {
              Get.back();
            } else {
              controller.previousStep();
            }
          },
        )),
        actions: [
          Obx(() {
            if (controller.currentStep.value > 0 && controller.currentStep.value < 3) {
              return TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: textGrey, fontSize: 14.sp),
                ),
              );
            }
            if (controller.currentStep.value == 3) {
              return IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {},
              );
            }
            return const SizedBox.shrink();
          })
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: _buildCurrentStep(context),
              ),
            ),
            _buildBottomBar(context),
          ],
        );
      }),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getStepTitle(),
                style: TextStyle(
                  color: textGrey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                _getStepProgressText(),
                style: TextStyle(
                  color: primaryPurple,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: List.generate(4, (index) {
              bool isActive = index <= controller.currentStep.value;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 8.w),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isActive ? primaryPurple : cardBackground,
                    borderRadius: BorderRadius.circular(2.r),
                    gradient: isActive && index == controller.currentStep.value && index == 3
                        ? const LinearGradient(colors: [primaryPurple, accentPurple])
                        : null,
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (controller.currentStep.value) {
      case 0: return "STEP 1: BASIC INFO";
      case 1: return "STEP 2 OF 4";
      case 2: return "STEP 3 OF 4";
      case 3: return "STEP 4 OF 4";
      default: return "";
    }
  }

  String _getStepProgressText() {
    switch (controller.currentStep.value) {
      case 0: return "1 / 4";
      case 1: return "50%";
      case 2: return "75%";
      case 3: return "100% Complete";
      default: return "";
    }
  }

  Widget _buildCurrentStep(BuildContext context) {
    switch (controller.currentStep.value) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      case 3: return _buildStep4(context);
      default: return _buildStep1();
    }
  }

  // --- STEP 1 ---
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "Let's start with",
          style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          "the basics",
          style: TextStyle(color: const Color(0xFF3B82F6), fontSize: 32.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Text(
          "Every great project needs a memorable identity.",
          style: TextStyle(color: textGrey, fontSize: 14.sp),
        ),
        SizedBox(height: 40.h),
        
        _buildTextFieldLabel("PROJECT TITLE *"),
        _buildCustomTextField(
          controller: controller.titleController,
          hint: "e.g. EcoSphere AI",
          icon: MaterialCommunityIcons.rocket_launch_outline,
        ),
        
        SizedBox(height: 24.h),
        _buildTextFieldLabel("SHORT TAGLINE *"),
        _buildCustomTextField(
          controller: controller.taglineController,
          hint: "A one-sentence pitch of your idea",
          icon: MaterialCommunityIcons.flare,
        ),

        SizedBox(height: 24.h),
        _buildTextFieldLabel("PROJECT DESCRIPTION *"),
        _buildCustomTextField(
          controller: controller.descriptionController,
          hint: "Detail what your project does...",
          icon: MaterialCommunityIcons.text_long,
          maxLines: 4,
        ),
      ],
    );
  }

  // --- STEP 2 ---
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Media Assets",
          style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Text(
          "Add high-quality images or videos to showcase your project's best features. Make sure to upload images, a video, a report, and a Presentation.",
          style: TextStyle(color: textGrey, fontSize: 14.sp, height: 1.5),
        ),
        SizedBox(height: 30.h),
        
        // Image Upload Area
        GestureDetector(
          onTap: () => controller.pickImages(),
          child: Container(
            width: double.infinity,
            height: 160.h,
            decoration: BoxDecoration(
              color: const Color(0xFF161B2E),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: primaryPurple.withOpacity(0.3), width: 1.5, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: primaryPurple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.image, color: const Color(0xFF3B82F6), size: 32.sp),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Upload Images *",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Tap to select images from Gallery",
                  style: TextStyle(color: textGrey, fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 20.h),
        Obx(() {
          if (controller.selectedImages.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("SELECTED IMAGES (${controller.selectedImages.length})", 
                style: TextStyle(color: textGrey, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              SizedBox(height: 16.h),
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImages.length,
                  itemBuilder: (context, index) {
                    final path = controller.selectedImages[index];
                    return Container(
                      width: 100.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: FileImage(File(path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          Positioned(
                            top: 8, right: 8,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(path),
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.close, color: Colors.white, size: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),

        SizedBox(height: 30.h),

        // Video, Report, PPT pickers
        _buildFileSelector("Upload Video (MP4) *", Icons.videocam, controller.selectedVideo.value, controller.pickVideo),
        SizedBox(height: 16.h),
        _buildFileSelector("Upload Project Report (PDF) *", Icons.picture_as_pdf, controller.selectedReport.value, controller.pickReport),
        SizedBox(height: 16.h),
        _buildFileSelector("Upload Project PPT (PDF) *", Icons.slideshow, controller.selectedPpt.value, controller.pickPpt),
      ],
    );
  }

  Widget _buildFileSelector(String title, IconData icon, String selectedValue, VoidCallback onTap) {
    bool hasFile = selectedValue.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2237),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: hasFile ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: hasFile ? const Color(0xFF3B82F6) : textGrey, size: 24.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile ? selectedValue.split('/').last : title,
                    style: TextStyle(
                      color: hasFile ? Colors.white : textGrey,
                      fontSize: 14.sp,
                      fontWeight: hasFile ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasFile)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text("Tap to change", style: TextStyle(color: textGrey, fontSize: 10.sp)),
                    )
                ],
              ),
            ),
            Icon(hasFile ? Icons.check_circle : Icons.upload_file, color: hasFile ? const Color(0xFF3B82F6) : textGrey, size: 20.sp),
          ],
        ),
      ),
    );
  }

  // --- STEP 3 ---
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tech Stack & Links",
          style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Text(
          "Specify the core technologies and provide access to your hard work.",
          style: TextStyle(color: textGrey, fontSize: 14.sp, height: 1.5),
        ),
        SizedBox(height: 30.h),
        
        _buildTextFieldLabel("SEARCH TECHNOLOGIES *"),
        _buildCustomTextField(
          controller: controller.techSearchController,
          hint: "e.g. React, AI, Python (Press Enter to add)",
          icon: Icons.search,
          onSubmitted: (val) => controller.addTech(val),
        ),
        SizedBox(height: 16.h),
        
        Obx(() => Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ...controller.selectedTechs.map((tech) => Chip(
              label: Text(tech, style: const TextStyle(color: Color(0xFF3B82F6))),
              backgroundColor: const Color(0xFF1E293B),
              deleteIcon: const Icon(Icons.close, color: Color(0xFF3B82F6), size: 16),
              onDeleted: () => controller.removeTech(tech),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: const Color(0xFF3B82F6).withOpacity(0.3)),
              ),
            )).toList(),
          ],
        )),
        
        SizedBox(height: 30.h),
        _buildTextFieldLabel("REPOSITORY URL *"),
        _buildCustomTextField(
          controller: controller.repoUrlController,
          hint: "github.com/your-username/repo",
          icon: MaterialCommunityIcons.code_tags,
        ),
        
        SizedBox(height: 24.h),
        _buildTextFieldLabel("LIVE DEMO LINK (Optional)"),
        _buildCustomTextField(
          controller: controller.demoLinkController,
          hint: "https://your-project.vercel.app",
          icon: MaterialCommunityIcons.web,
          iconColor: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  // --- STEP 4 ---
  Widget _buildStep4(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ready to Launch",
          style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.h),
        
        // Preview Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F30),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/screen.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xFF1A1F30)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12.h, right: 12.w,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: Icon(Icons.edit, color: Colors.white, size: 16.sp),
                      ),
                    ),
                    Positioned(
                      bottom: 16.h, left: 16.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.2), borderRadius: BorderRadius.circular(4.r)),
                                child: Text("ENGINEERING", style: TextStyle(color: const Color(0xFF3B82F6), fontSize: 10.sp, fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(color: primaryPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(4.r)),
                                child: Text("REVIEW", style: TextStyle(color: accentPurple, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            controller.titleController.text.isNotEmpty ? controller.titleController.text : "NeuroNexus AI\nPlatform",
                            style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, height: 1.2),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("PROJECT SUMMARY", style: TextStyle(color: textGrey, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            Icon(Icons.edit_note, color: textGrey, size: 20.sp),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2237),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.2), borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.description, color: const Color(0xFF3B82F6), size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  controller.descriptionController.text.isNotEmpty 
                      ? controller.descriptionController.text 
                      : "An autonomous neural network system designed to optimize energy consumption...",
                  style: TextStyle(color: Colors.white, fontSize: 13.sp, height: 1.5),
                ),
              )
            ],
          ),
        ),
        
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("TECH STACK", style: TextStyle(color: textGrey, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            Icon(Icons.code, color: textGrey, size: 20.sp),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: controller.selectedTechs.map((tech) => _buildTechChip(tech, Colors.cyan)).toList(),
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: const Color(0xFF1C2237), borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.people_alt, color: const Color(0xFF3B82F6), size: 24.sp),
                    SizedBox(height: 16.h),
                    Text("TEAM SIZE", style: TextStyle(color: textGrey, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    TextField(
                      controller: controller.teamSizeController,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: "E.g. 4 Members",
                        hintStyle: TextStyle(color: textGrey, fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: const Color(0xFF1C2237), borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.calendar_month, color: const Color(0xFF3B82F6), size: 24.sp),
                    SizedBox(height: 16.h),
                    Text("DURATION", style: TextStyle(color: textGrey, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    TextField(
                      controller: controller.durationController,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: "E.g. 3 Months",
                        hintStyle: TextStyle(color: textGrey, fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(color: const Color(0xFF1C2237), borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person, color: const Color(0xFF3B82F6), size: 24.sp),
              SizedBox(height: 16.h),
              Text("MEMBER NAME", style: TextStyle(color: textGrey, fontSize: 10.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.h),
              TextField(
                controller: controller.memberNameController,
                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: "Add member name...",
                  hintStyle: TextStyle(color: textGrey, fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: const Color(0xFF1C2237), borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.link, color: const Color(0xFF3B82F6), size: 24.sp),
                    SizedBox(height: 16.h),
                    Text("REPOSITORY", style: TextStyle(color: textGrey, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text(controller.repoUrlController.text, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: const Color(0xFF1C2237), borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.public, color: const Color(0xFF3B82F6), size: 24.sp),
                    SizedBox(height: 16.h),
                    Text("LIVE DEMO", style: TextStyle(color: textGrey, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text(controller.demoLinkController.text.isNotEmpty ? controller.demoLinkController.text : "N/A", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("MEDIA & FILES", style: TextStyle(color: textGrey, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            GestureDetector(
              onTap: () => _showAllMediaDialog(context),
              child: Text("View All", style: TextStyle(color: const Color(0xFF3B82F6), fontSize: 13.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: controller.selectedImages.take(3).map((path) => _buildMediaThumb(path)).toList(),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(color: const Color(0xFF1C2237), borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            children: [
              if (controller.selectedVideo.value.isNotEmpty)
                _buildFinalFileRow(Icons.videocam, controller.selectedVideo.value),
              if (controller.selectedReport.value.isNotEmpty)
                _buildFinalFileRow(Icons.picture_as_pdf, controller.selectedReport.value),
              if (controller.selectedPpt.value.isNotEmpty)
                _buildFinalFileRow(Icons.slideshow, controller.selectedPpt.value),
            ],
          ),
        ),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildFinalFileRow(IconData icon, String path) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3B82F6), size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              path.split('/').last,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String label, Color dotColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2237),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6.w, height: 6.w, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          SizedBox(width: 8.w),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMediaThumb(String path) {
    return Expanded(
      child: Container(
        height: 80.h,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2237),
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: FileImage(File(path)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // --- REUSABLES ---
  Widget _buildTextFieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(color: textGrey, fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    Color iconColor = textGrey,
    int maxLines = 1,
    Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2237),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textGrey.withOpacity(0.5)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: maxLines > 1 ? (16.h * maxLines) / 2 : 0),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        ),
      ),
    );
  }

  // --- BOTTOM BAR ---
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: const Color(0xFF10121A),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: controller.currentStep.value > 0 && controller.currentStep.value < 3
      ? Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () => controller.previousStep(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text("Back", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18.sp),
                  ],
                ),
              ),
            ),
          ],
      )
      : ElevatedButton(
        onPressed: () {
          if (controller.currentStep.value < 3) {
            controller.nextStep();
          } else {
            _showSuccessDialog(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.currentStep.value == 3 ? const Color(0xFF8B5CF6) : const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          minimumSize: const Size(double.infinity, 0),
          elevation: controller.currentStep.value == 3 ? 10 : 0,
          shadowColor: controller.currentStep.value == 3 ? const Color(0xFF8B5CF6).withOpacity(0.5) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.currentStep.value == 3) Icon(MaterialCommunityIcons.rocket_launch, color: Colors.white, size: 20.sp),
            if (controller.currentStep.value == 3) SizedBox(width: 8.w),
            Text(
              controller.currentStep.value == 3 ? "Publish Project" : "Continue", 
              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)
            ),
            if (controller.currentStep.value < 3) SizedBox(width: 8.w),
            if (controller.currentStep.value < 3) Icon(Icons.arrow_forward, color: Colors.white, size: 18.sp),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xFF10121A).withOpacity(0.95),
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: 50.h, right: 20.w,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                  ),
                ),
              ),
              
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 250.w, height: 250.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.1), width: 1),
                            ),
                          ),
                          Container(
                            width: 200.w, height: 200.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2), width: 1),
                            ),
                          ),
                          Container(
                            width: 150.w, height: 150.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Icon(MaterialCommunityIcons.check_decagram, color: const Color(0xFF2563EB), size: 100.sp),
                        ],
                      ),
                      
                      SizedBox(height: 40.h),
                      Text(
                        "Project Published!",
                        style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Your innovative project is now live for\nthe ProjexHub community to explore.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textGrey, fontSize: 16.sp, height: 1.5),
                      ),
                      
                      SizedBox(height: 60.h),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: Text("View Project", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 16.h),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          minimumSize: const Size(double.infinity, 0),
                        ),
                        child: Text("Share to Community", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  void _showAllMediaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1F30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Container(
            padding: EdgeInsets.all(20.r),
            height: 500.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All Media & Files", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    )
                  ],
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (controller.selectedImages.isNotEmpty) ...[
                        Text("Images", style: TextStyle(color: textGrey, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.selectedImages.map((path) => Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
                            ),
                          )).toList(),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      if (controller.selectedVideo.value.isNotEmpty || controller.selectedReport.value.isNotEmpty || controller.selectedPpt.value.isNotEmpty) ...[
                        Text("Files", style: TextStyle(color: textGrey, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        if (controller.selectedVideo.value.isNotEmpty)
                          _buildFinalFileRow(Icons.videocam, controller.selectedVideo.value),
                        if (controller.selectedReport.value.isNotEmpty)
                          _buildFinalFileRow(Icons.picture_as_pdf, controller.selectedReport.value),
                        if (controller.selectedPpt.value.isNotEmpty)
                          _buildFinalFileRow(Icons.slideshow, controller.selectedPpt.value),
                      ],
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

