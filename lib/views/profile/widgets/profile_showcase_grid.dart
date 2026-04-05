
import 'package:app/views/profile/project_update_page.dart';
import 'package:app/views/uploadProject/project_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../common/app_style.dart';
import '../../../controllers/project_controller.dart';
import '../../../models/project_response.dart';
import '../../project/project_details_page.dart';

class ProfileShowcaseGrid extends StatefulWidget {
  const ProfileShowcaseGrid({super.key});

  @override
  State<ProfileShowcaseGrid> createState() =>
      _ProfileShowcaseGridState();
}

class _ProfileShowcaseGridState
    extends State<ProfileShowcaseGrid> {
  bool isGridView = true;
  final ProjectController projectController =
      Get.find<ProjectController>();

  @override
  void initState() {
    super.initState();
    projectController.fetchApprovedUserProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 🔹 HEADER
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Showcase",
              style:
                  appStyle(20, Colors.white, FontWeight.bold),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isGridView = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: isGridView
                          ? const Color(0xFF0F52FF)
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.grid_view,
                        color: Colors.white,
                        size: 18.sp),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isGridView = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: !isGridView
                          ? const Color(0xFF0F52FF)
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.view_agenda,
                        color: Colors.white,
                        size: 18.sp),
                  ),
                ),
              ],
            )
          ],
        ),

        SizedBox(height: 16.h),

        /// 🔹 DATA VIEW
        Obx(() {
          if (projectController.isLoading &&
              projectController
                  .approvedUserProjects.isEmpty) {
            return Center(
              child: Lottie.asset(
                "assets/anime/loading.json",
                height: 100.h,
                width: 100.w,
                fit: BoxFit.cover,
              ),
            );
          }

          final projects =
              projectController.approvedUserProjects;

          return isGridView
              ? GridView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: projects.length + 1,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    if (index == projects.length) {
                      return _buildAddCard();
                    }
                    return _buildProjectCard(
                        context, projects[index]);
                  },
                )
              : ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: projects.length + 1,
                  itemBuilder: (context, index) {
                    if (index == projects.length) {
                      return _buildAddCard();
                    }
                    return _buildListCard(
                        context, projects[index]);
                  },
                );
        }),
      ],
    );
  }

  /// 🔹 GRID CARD
  Widget _buildProjectCard(
      BuildContext context, ProjectResponse data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(
              projectId: data.id,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(16.r),
                    image: DecorationImage(
                      image: NetworkImage(
                        data.images.isNotEmpty
                            ? data.images[0]
                            : "https://via.placeholder.com/300",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// OPTIONS ICON
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      _showProjectOptions(data);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.more_vert,
                          color: Colors.white,
                          size: 18),
                    ),
                  ),
                ),

                /// CATEGORY
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(
                                8.r),
                      ),
                      child: Text(
                        data.categories.isNotEmpty
                            ? data.categories
                                .join(' & ')
                                .toUpperCase()
                            : "GENERAL",
                        style: appStyle(
                            10,
                            Colors.white,
                            FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            data.title,
            style: appStyle(
                14, Colors.white, FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.star,
                  color: Colors.yellow, size: 12.sp),
              SizedBox(width: 4.w),
              Text(
                data.likeCount.toString(),
                style: appStyle(12,
                    Colors.grey.shade400,
                    FontWeight.w500),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.comment,
                  color: Colors.blueAccent,
                  size: 12.sp),
              SizedBox(width: 4.w),
              Text(
                data.comments.length.toString(),
                style: appStyle(12,
                    Colors.grey.shade400,
                    FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 🔹 LIST CARD
  Widget _buildListCard(
      BuildContext context, ProjectResponse data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(
              projectId: data.id,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius:
              BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: NetworkImage(
                    data.images.isNotEmpty
                        ? data.images[0]
                        : "https://via.placeholder.com/300",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: appStyle(
                        14,
                        Colors.white,
                        FontWeight.bold),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    data.categories.isNotEmpty
                        ? data.categories.join(" & ")
                            .toUpperCase()
                        : "GENERAL",
                    style: appStyle(12,
                        Colors.grey,
                        FontWeight.w500),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star,
                          color: Colors.yellow,
                          size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        data.likeCount.toString(),
                        style: appStyle(
                            12,
                            Colors.grey.shade400,
                            FontWeight.w500),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.comment,
                          color: Colors.blueAccent,
                          size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        data.comments.length
                            .toString(),
                        style: appStyle(
                            12,
                            Colors.grey.shade400,
                            FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// OPTIONS ICON
            GestureDetector(
              onTap: () {
                _showProjectOptions(data);
              },
              child: Icon(Icons.more_vert,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 ADD CARD
  Widget _buildAddCard() {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProjectUploadPage());
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius:
              BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(Icons.add,
                  color: Colors.grey.shade600,
                  size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                "ADD NEW",
                style: appStyle(
                        12,
                        Colors.grey.shade600,
                        FontWeight.bold)
                    .copyWith(letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 BOTTOM SHEET
  void _showProjectOptions(ProjectResponse data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius:
                    BorderRadius.vertical(
                        top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin:
                        EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.edit,
                        color: Colors.blue),
                    title: Text("Edit Project",
                        style: appStyle(
                            14,
                            Colors.white,
                            FontWeight.w600)),
                    onTap: () {
                    Get.to(() => EditProjectPage(project: data));
                    },
                  ),

                  Divider(color: Colors.white10),

                  ListTile(
                    leading: Icon(Icons.delete,
                        color: Colors.red),
                    title: Text("Delete Project",
                        style: appStyle(
                            14,
                            Colors.red,
                            FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(
                          data);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 🔹 DELETE CONFIRMATION
  void _showDeleteConfirmation(
      ProjectResponse data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF1E1E2E),
          title: Text("Delete Project",
              style: appStyle(16,
                  Colors.white, FontWeight.bold)),
          content: Text(
            "Are you sure you want to delete this project?",
            style: appStyle(
                13, Colors.grey, FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: Text("Cancel",
                  style:
                      TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await projectController
                    .deleteProject(data.id);

                await projectController
                    .fetchApprovedUserProjects();
              },
              child: Text("Delete",
                  style:
                      TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}