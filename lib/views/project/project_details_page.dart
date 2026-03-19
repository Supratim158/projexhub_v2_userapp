import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../common/app_style.dart';
import '../../constants/constants.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Map<String, dynamic> projectData;

  const ProjectDetailsPage({super.key, required this.projectData});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  // Add controllers for video if video is present
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoUrl = widget.projectData['videoUrl'];
    if (videoUrl != null && videoUrl.toString().isNotEmpty) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: false,
            looping: false,
            aspectRatio: _videoPlayerController!.value.aspectRatio,
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
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
    // Mocking some extra data if not present in projectData map
    final String githubUrl = widget.projectData['githubUrl'] ?? 'https://github.com';
    final String demoUrl = widget.projectData['demoUrl'] ?? 'https://flutter.dev';
    final String overview = widget.projectData['overview'] ?? 
        "The Quantum Neural Interface is a revolutionary middleware that bridges the gap between traditional neural networks and emerging quantum computing architectures. By utilizing entangled qubit states for weight representation, this project achieves a 40% reduction in training latency for complex LLMs.";
    final String leadEngineer = widget.projectData['leadEngineer'] ?? "Alex Rivera";
    final String uiUxResearch = widget.projectData['uiUxResearch'] ?? "Sarah Chen";
    final String teamSize = widget.projectData['teamSize'] ?? "4 Members";
    final String duration = widget.projectData['duration'] ?? "6 Months";

    // Media
    final List<String> photos = widget.projectData['photos'] ?? [];
    final String? pdfUrl = widget.projectData['pdfUrl'];
    final String? pptUrl = widget.projectData['pptUrl'];

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A), // darker background like the design
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PROJECT SHOWCASE",
                    style: appStyle(12, Colors.blueAccent, FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.projectData['title'] ?? "Project Title",
                    style: appStyle(24, Colors.white, FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.projectData['subtitle'] ?? "Project subtitle representing tagline.",
                    style: appStyle(14, Colors.white.withOpacity(0.8), FontWeight.normal),
                  ),
                  
                  SizedBox(height: 24.h),
                  _buildActionButtons(githubUrl, demoUrl),
                  
                  SizedBox(height: 24.h),
                  _buildStatsCards(teamSize, duration),
                  
                  SizedBox(height: 32.h),
                  _buildProjectOverview(overview, leadEngineer, uiUxResearch),

                  SizedBox(height: 32.h),
                  _buildMediaSection(photos, pdfUrl, pptUrl),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.h,
      pinned: true,
      backgroundColor: const Color(0xFF0F111A),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "PROJEXHUB V2",
        style: appStyle(16, Colors.white, FontWeight.bold).copyWith(letterSpacing: 1.5),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background image placeholder with a gradient look
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/default.png'), // fallback image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient Overlay specific to design
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F111A).withOpacity(0.1),
                    const Color(0xFF0F111A).withOpacity(0.6),
                    const Color(0xFF0F111A), // match background at bottom
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String githubUrl, String demoUrl) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _launchUrl(githubUrl),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.code, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text("View GitHub", style: appStyle(14, Colors.white, FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: GestureDetector(
            onTap: () => _launchUrl(demoUrl),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1C64F2), // solid blue like design
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rocket_launch, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text("Live Demo", style: appStyle(14, Colors.white, FontWeight.bold)),
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF151722), // slightly lighter than background
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F36), // darker bluish
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.people, color: Colors.blueAccent, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TEAM SIZE", style: appStyle(10, Colors.white.withOpacity(0.5), FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text(teamSize, style: appStyle(14, Colors.white, FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                  child: Icon(Icons.access_time, color: Colors.blueAccent, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DURATION", style: appStyle(10, Colors.white.withOpacity(0.5), FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text(duration, style: appStyle(14, Colors.white, FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectOverview(String overview, String leadEngineer, String uiUxResearch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.description, color: Colors.blueAccent, size: 20.sp),
            SizedBox(width: 8.w),
            Text("Project Overview", style: appStyle(18, Colors.white, FontWeight.bold)),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF151722),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overview,
                style: appStyle(14, Colors.white.withOpacity(0.7), FontWeight.normal).copyWith(
                  height: 1.6,
                ),
              ),
              SizedBox(height: 24.h),
              Divider(color: Colors.white.withOpacity(0.1)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("LEAD ENGINEER", style: appStyle(10, Colors.white.withOpacity(0.5), FontWeight.bold)),
                        SizedBox(height: 4.h),
                        Text(leadEngineer, style: appStyle(14, Colors.white, FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UI/UX RESEARCH", style: appStyle(10, Colors.white.withOpacity(0.5), FontWeight.bold)),
                        SizedBox(height: 4.h),
                        Text(uiUxResearch, style: appStyle(14, Colors.white, FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMediaSection(List<String> photos, String? pdfUrl, String? pptUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.perm_media, color: Colors.blueAccent, size: 20.sp),
            SizedBox(width: 8.w),
            Text("Project Media", style: appStyle(18, Colors.white, FontWeight.bold)),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Photos
        if (photos.isNotEmpty) ...[
          Text("Screenshots & Photos", style: appStyle(14, Colors.white, FontWeight.w600)),
          SizedBox(height: 12.h),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 200.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    image: DecorationImage(
                      image: NetworkImage(photos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24.h),
        ],

        // Video
        if (_videoPlayerController != null && _chewieController != null) ...[
          Text("Demo Video", style: appStyle(14, Colors.white, FontWeight.w600)),
          SizedBox(height: 12.h),
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],

        // Documents (PDF, PPT)
        if (pdfUrl != null || pptUrl != null) ...[
          Text("Documents", style: appStyle(14, Colors.white, FontWeight.w600)),
          SizedBox(height: 12.h),
          Row(
            children: [
              if (pdfUrl != null)
                Expanded(
                  child: _buildDocCard("Project Report", "PDF", Icons.picture_as_pdf, Colors.redAccent, () => _launchUrl(pdfUrl)),
                ),
              if (pdfUrl != null && pptUrl != null) SizedBox(width: 16.w),
              if (pptUrl != null)
                Expanded(
                  child: _buildDocCard("Presentation", "PPT", Icons.slideshow, Colors.orangeAccent, () => _launchUrl(pptUrl)),
                ),
            ],
          )
        ],
      ],
    );
  }

  Widget _buildDocCard(String title, String type, IconData icon, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF151722),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: appStyle(14, Colors.white, FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4.h),
                  Text(type, style: appStyle(10, Colors.white.withOpacity(0.5), FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
