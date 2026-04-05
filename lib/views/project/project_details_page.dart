import 'package:app/constants/constants.dart';
import 'package:app/controllers/project_controller.dart';
import 'package:app/views/login/signin_page.dart';
import 'package:app/views/project/ai/ai_analyzer.dart';
import 'package:app/views/project/comments/comment_sheet.dart';
import 'package:app/views/project/image_gallery_view.dart';
import 'package:app/views/project/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/app_style.dart';
import 'package:lottie/lottie.dart';

class ProjectDetailsPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailsPage({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final projectController = Get.find<ProjectController>();

  @override
  void initState() {
    super.initState();
    projectController.fetchProjectById(widget.projectId);
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;

    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    String? token = box.read('token');

    if (token == null) {
      return SigninPage();
    }

    return Obx(() {
      // Loading state
      if (projectController.isFetchingProjectDetails) {
        return Scaffold(
          backgroundColor: Color(0xFF0F111A),
          body: Center(
        child: Lottie.asset(
        "assets/anime/loading.json",
          height: 100.h,
          width: 100.w,
          fit: BoxFit.cover,
        ),
      )
        );
      }

      final project = projectController.selectedProject;

      // No data state
      if (project == null) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F111A),
          body: Center(
            child: Text(
              "Project not found.",
              style: appStyle(16, Colors.grey, FontWeight.normal),
            ),
          ),
        );
      }

      final String status = project.status;
      final String demoUrl = project.demoLink;
      final String githubUrl = project.repoLink;
      final String overview = project.description;
      final List<String> memberNames = project.memberNames;
      final List<String> memberIds = project.memberIds;
      final List<String> techStack = project.technologies;
      final String teamSize = "${project.memberSize} Members";
      final String duration = project.duration;
      final List<String> photos = project.images;
      final String? pdfUrl = project.projectReportPdf;
      final String? pptUrl = project.projectPptPdf;
      final String? videoUrl = project.video;

      return Scaffold(
        backgroundColor: const Color(0xFF0F111A),
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(photos),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          if (project.categories.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                  color: Colors.blueAccent.withOpacity(0.3)),
                            ),
                            child: Text(
                              project.categories.join(' & ').toUpperCase(),
                              style:
                                  appStyle(12, Colors.blueAccent, FontWeight.bold),
                            ),
                          ),

                          buildStatusBadge(project.status),
                        ],
                      ),
                    SizedBox(height: 8.h),
                    Text(
                      project.title,
                      style: appStyle(24, Colors.white, FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      project.tagline,
                      style: appStyle(
                          14, Colors.white.withOpacity(0.8), FontWeight.normal),
                    ),
                    SizedBox(height: 24.h),
                    _buildActionButtons(githubUrl, demoUrl),
                    SizedBox(height: 24.h),
                    _buildStatsCards(teamSize, duration),
                    SizedBox(height: 32.h),
                    _buildProjectOverview(overview, memberNames, techStack, memberIds),
                    SizedBox(height: 32.h),
                    _buildMediaSection(photos, pdfUrl, pptUrl, videoUrl),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            /// 🔥 LIKE & COMMENT BOX (NEW)
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 1,
                    spreadRadius: 2
                  )
                ],
              ),
              child: Column(
                children: [
                  /// 👍 LIKE
                  IconButton(
                      icon: Icon(
                        projectController.isLiked.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () =>
                          projectController.toggleLike(project.id),
                    ),
                    Text("${projectController.likeCount.value} Stars",
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),

                  SizedBox(height: 12.h),

                  /// 💬 COMMENT
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CommentSheet(projectId: project.id),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(Icons.chat_bubble_outline,
                          color: Colors.white, size: 22.sp),
                        SizedBox(height: 4.h),
                        Text("${projectController.comments.length} Comments",
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 🤖 EXISTING AI BUTTON
            GestureDetector(
              onTap: () {
                Get.to(() => AIAnalyzerPage(
                      projectId: project.id,
                    ));
              },
              child: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSliverAppBar(List<String> photos) {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      backgroundColor: const Color(0xFF0F111A),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "PROJECT DETAILS",
        style: appStyle(16, Colors.white, FontWeight.bold)
            .copyWith(letterSpacing: 1.5),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/screen.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F111A).withOpacity(0.1),
                    const Color(0xFF0F111A).withOpacity(0.6),
                    const Color(0xFF0F111A),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String githubUrl, String demoUrl) {
    bool hasDemo = demoUrl.trim().isNotEmpty &&
        demoUrl.trim().toLowerCase() != 'n/a' &&
        demoUrl.trim().toLowerCase() != 'null';

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _launchUrl(githubUrl),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.code, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text("View GitHub",
                      style: appStyle(14, Colors.white, FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        if (hasDemo) SizedBox(width: 16.w),
        if (hasDemo)
          Expanded(
            child: GestureDetector(
              onTap: () => _launchUrl(demoUrl),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C64F2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, color: Colors.white, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text("Live Demo",
                        style: appStyle(14, Colors.white, FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsCards(String teamSize, String duration) {
    return Row(
      children: [
        Expanded(
          child: _statCard(Icons.people, "TEAM SIZE", teamSize),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _statCard(Icons.access_time, "DURATION", '$duration Months'),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF151722),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F36),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: appStyle(
                      10, Colors.white.withOpacity(0.5), FontWeight.bold)),
              SizedBox(height: 4.h),
              Text(value, style: appStyle(14, Colors.white, FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectOverview(String overview, List<String> memberNames, List<String> techStack, List<String> memberIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Project Overview",
            style: appStyle(18, Colors.white, FontWeight.bold)),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF151722),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            overview,
            style:
                appStyle(14, Colors.white.withOpacity(0.7), FontWeight.normal)
                    .copyWith(height: 1.6),
          ),
        ),

        SizedBox(height: 16.h),
        if (memberNames.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tech Stack",
                  style: appStyle(16, Colors.white, FontWeight.bold)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: techStack
                    .map((name) => Chip(
                          label: Text(name,
                              style:
                                  appStyle(12, Colors.white, FontWeight.w500)),
                          backgroundColor: const Color(0xFF1A1F36),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.1)),
                        ))
                    .toList(),
              ),
            ],
          ),


        SizedBox(height: 16.h),
        if (memberNames.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Team Members",
                  style: appStyle(16, Colors.white, FontWeight.bold)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: memberNames
                    .map((name) => Chip(
                          label: Text(name,
                              style:
                                  appStyle(12, Colors.white, FontWeight.w500)),
                          backgroundColor: const Color(0xFF1A1F36),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.1)),
                        ))
                    .toList(),
              ),
            ],
          ),

          SizedBox(height: 16.h),
        if (memberIds.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Team Members IDs",
                  style: appStyle(16, Colors.white, FontWeight.bold)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: memberIds
                    .map((name) => Chip(
                          label: Text(name,
                              style:
                                  appStyle(12, Colors.white, FontWeight.w500)),
                          backgroundColor: const Color(0xFF1A1F36),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.1)),
                        ))
                    .toList(),
              ),
            ],
          ),

          
      ],
    );
  }

  /// ✅ MEDIA SECTION
  Widget _buildMediaSection(
      List<String> photos, String? pdfUrl, String? pptUrl, String? videoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Project Media",
            style: appStyle(18, Colors.white, FontWeight.bold)),
        SizedBox(height: 16.h),

        /// IMAGES
        if (photos.isNotEmpty)
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ImageGalleryView(
                          images: photos,
                          initialIndex: index,
                        ));
                  },
                  child: Container(
                    width: 200.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: NetworkImage(photos[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        SizedBox(height: 20.h),

        /// VIDEO
        if (videoUrl != null && videoUrl.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Project Demo",
                  style: appStyle(16, Colors.white, FontWeight.bold)),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () => _launchUrl(videoUrl),
                child: Container(
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xFF151722),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Dark overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),

                      /// Play Icon
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 50.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Watch Demo",
                            style: appStyle(14, Colors.white, FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        SizedBox(height: 20.h),

        /// PDF
        if (pdfUrl != null && pdfUrl.isNotEmpty)
          GestureDetector(
            onTap: () => _launchUrl(pdfUrl),
            child: Container(
              padding: EdgeInsets.all(14.w),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf,
                      color: Colors.redAccent, size: 22.sp),
                  SizedBox(width: 12.w),
                  Text("View Project Report",
                      style: appStyle(14, Colors.white, FontWeight.bold)),
                ],
              ),
            ),
          ),

        /// PPT
        if (pptUrl != null && pptUrl.isNotEmpty)
          GestureDetector(
            onTap: () => _launchUrl(pptUrl),
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: const Color(0xFF151722),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Icon(Icons.slideshow,
                      color: Colors.orangeAccent, size: 22.sp),
                  SizedBox(width: 12.w),
                  Text("View Project PPT",
                      style: appStyle(14, Colors.white, FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
