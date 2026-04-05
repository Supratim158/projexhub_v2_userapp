import 'dart:io';
import 'package:app/views/entrypoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../constants/constants.dart';
import '../../controllers/project_controller.dart';
import '../../controllers/project_upload_controller.dart';
import '../../models/project_response.dart';
import '../../models/project_model.dart';

class EditProjectPage extends StatefulWidget {
  final ProjectResponse project;

  const EditProjectPage({super.key, required this.project});

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final ProjectController controller = Get.find();
  late ProjectUploadController uploadController;

  late TextEditingController titleController;
  late TextEditingController taglineController;
  late TextEditingController descriptionController;
  late TextEditingController repoController;
  late TextEditingController demoController;
  late TextEditingController techSearchController;
  late TextEditingController memberNameInputController;
  late TextEditingController memberIdInputController;
  late TextEditingController teamSizeController;
  late TextEditingController durationController;

  final ImagePicker _picker = ImagePicker();

  // Existing cloud URLs (from the project)
  late List<String> existingImageUrls;
  late String existingVideoUrl;
  late String existingReportUrl;
  late String existingPptUrl;

  // Newly picked local file paths
  List<String> newLocalImages = [];
  String? newLocalVideo;
  String? newLocalReport;
  String? newLocalPpt;

  // Editable list fields
  final List<String> availableCategories = ["AI", "ML", "IoT", "App", "Web", "Blockchain", "Others"];
  late List<String> selectedCategories;
  late List<String> selectedTechs;
  late List<String> memberNames;
  late List<String> memberIds;

  bool _isUpdating = false;
  String _uploadStatus = '';

  @override
  void initState() {
    super.initState();
    uploadController = Get.put(ProjectUploadController());

    titleController = TextEditingController(text: widget.project.title);
    taglineController = TextEditingController(text: widget.project.tagline);
    descriptionController =
        TextEditingController(text: widget.project.description);
    repoController = TextEditingController(text: widget.project.repoLink);
    demoController = TextEditingController(text: widget.project.demoLink);
    techSearchController = TextEditingController();
    memberNameInputController = TextEditingController();
    memberIdInputController = TextEditingController();
    teamSizeController = TextEditingController(text: widget.project.memberSize.toString());
    durationController = TextEditingController(text: widget.project.duration.toString());

    existingImageUrls = List<String>.from(widget.project.images);
    existingVideoUrl = widget.project.video;
    existingReportUrl = widget.project.projectReportPdf;
    existingPptUrl = widget.project.projectPptPdf;

    selectedCategories = List<String>.from(widget.project.categories);
    selectedTechs = List<String>.from(widget.project.technologies);
    memberNames = List<String>.from(widget.project.memberNames);
    memberIds = List<String>.from(widget.project.memberIds);
  }

  @override
  void dispose() {
    titleController.dispose();
    taglineController.dispose();
    descriptionController.dispose();
    repoController.dispose();
    demoController.dispose();
    techSearchController.dispose();
    memberNameInputController.dispose();
    memberIdInputController.dispose();
    teamSizeController.dispose();
    durationController.dispose();
    super.dispose();
  }

  // ─── IMAGE PICKING ───
  Future<void> _pickNewImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        newLocalImages.addAll(images.map((e) => e.path));
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      existingImageUrls.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      newLocalImages.removeAt(index);
    });
  }

  // ─── VIDEO PICKING ───
  Future<void> _pickNewVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        newLocalVideo = video.path;
      });
    }
  }

  void _removeVideo() {
    setState(() {
      existingVideoUrl = '';
      newLocalVideo = null;
    });
  }

  // ─── PDF PICKING ───
  Future<void> _pickNewReport() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        newLocalReport = result.files.single.path!;
      });
    }
  }

  void _removeReport() {
    setState(() {
      existingReportUrl = '';
      newLocalReport = null;
    });
  }

  // ─── PPT PICKING ───
  Future<void> _pickNewPpt() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'ppt', 'pptx']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        newLocalPpt = result.files.single.path!;
      });
    }
  }

  void _removePpt() {
    setState(() {
      existingPptUrl = '';
      newLocalPpt = null;
    });
  }

  // ─── SUBMIT UPDATE ───
  Future<void> _handleUpdate() async {
    // Add any pending inputs
    if (techSearchController.text.trim().isNotEmpty && !selectedTechs.contains(techSearchController.text.trim())) {
      selectedTechs.add(techSearchController.text.trim());
      techSearchController.clear();
    }
    if (memberNameInputController.text.trim().isNotEmpty) {
      memberNames.add(memberNameInputController.text.trim());
      memberNameInputController.clear();
    }
    if (memberIdInputController.text.trim().isNotEmpty) {
      memberIds.add(memberIdInputController.text.trim());
      memberIdInputController.clear();
    }

    setState(() {
      _isUpdating = true;
      _uploadStatus = 'Preparing...';
    });

    try {
      // 1. Upload new images to Cloudinary
      List<String> finalImageUrls = List<String>.from(existingImageUrls);
      for (int i = 0; i < newLocalImages.length; i++) {
        setState(() {
          _uploadStatus =
              'Uploading new image ${i + 1}/${newLocalImages.length}...';
        });
        String? url =
            await uploadController.uploadToCloudinary(newLocalImages[i], 'image');
        if (url != null) {
          finalImageUrls.add(url);
        } else {
          Get.snackbar("Upload Failed", "Failed to upload image ${i + 1}",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          setState(() {
            _isUpdating = false;
            _uploadStatus = '';
          });
          return;
        }
      }

      // 2. Upload new video if picked
      String finalVideoUrl = existingVideoUrl;
      if (newLocalVideo != null) {
        setState(() {
          _uploadStatus = 'Uploading video...';
        });
        String? url =
            await uploadController.uploadToCloudinary(newLocalVideo!, 'video');
        if (url != null) {
          finalVideoUrl = url;
        } else {
          Get.snackbar("Upload Failed", "Failed to upload video",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          setState(() {
            _isUpdating = false;
            _uploadStatus = '';
          });
          return;
        }
      }

      // 3. Upload new report if picked
      String finalReportUrl = existingReportUrl;
      if (newLocalReport != null) {
        setState(() {
          _uploadStatus = 'Uploading report...';
        });
        String? url =
            await uploadController.uploadToCloudinary(newLocalReport!, 'raw');
        if (url != null) {
          finalReportUrl = url;
        } else {
          Get.snackbar("Upload Failed", "Failed to upload report",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          setState(() {
            _isUpdating = false;
            _uploadStatus = '';
          });
          return;
        }
      }

      // 4. Upload new PPT if picked
      String finalPptUrl = existingPptUrl;
      if (newLocalPpt != null) {
        setState(() {
          _uploadStatus = 'Uploading presentation...';
        });
        String? url =
            await uploadController.uploadToCloudinary(newLocalPpt!, 'raw');
        if (url != null) {
          finalPptUrl = url;
        } else {
          Get.snackbar("Upload Failed", "Failed to upload presentation",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          setState(() {
            _isUpdating = false;
            _uploadStatus = '';
          });
          return;
        }
      }

      setState(() {
        _uploadStatus = 'Updating project...';
      });

      // 5. Build updated model and submit
      ProjectModel updatedProject = ProjectModel(
        title: titleController.text,
        tagline: taglineController.text,
        description: descriptionController.text,
        repoLink: repoController.text,
        demoLink: demoController.text,
        images: finalImageUrls,
        video: finalVideoUrl,
        projectReportPdf: finalReportUrl,
        projectPptPdf: finalPptUrl,
        technologies: selectedTechs,
        memberSize: int.tryParse(teamSizeController.text) ?? widget.project.memberSize,
        duration: durationController.text,
        memberNames: memberNames,
        categories: selectedCategories,
        memberIds: memberIds,
      );

      await controller.updateProject(widget.project.id, updatedProject);

      Get.to(() => const MainScreen()); // go back after update
    } catch (e) {
      debugPrint("Update error: $e");
      Get.snackbar("Error", "Failed to update project: $e",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }

    setState(() {
      _isUpdating = false;
      _uploadStatus = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Project",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isUpdating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFF3B82F6),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    _uploadStatus,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── SECTION: BASIC INFO ──
                        _buildSectionHeader("BASIC INFO", Icons.edit_note),
                        SizedBox(height: 16.h),
                        _buildLabel("PROJECT TITLE"),
                        _buildTextField(
                          controller: titleController,
                          hint: "Project title",
                          icon: MaterialCommunityIcons.rocket_launch_outline,
                        ),
                        SizedBox(height: 16.h),
                        _buildLabel("TAGLINE"),
                        _buildTextField(
                          controller: taglineController,
                          hint: "Short tagline",
                          icon: MaterialCommunityIcons.flare,
                        ),
                        SizedBox(height: 16.h),
                        _buildLabel("DESCRIPTION"),
                        _buildTextField(
                          controller: descriptionController,
                          hint: "Project description",
                          icon: MaterialCommunityIcons.text_long,
                          maxLines: 4,
                        ),
                        SizedBox(height: 16.h),
                        _buildLabel("REPO LINK"),
                        _buildTextField(
                          controller: repoController,
                          hint: "Repository URL",
                          icon: MaterialCommunityIcons.code_tags,
                        ),
                        SizedBox(height: 16.h),
                        _buildLabel("DEMO LINK"),
                        _buildTextField(
                          controller: demoController,
                          hint: "Demo URL (optional)",
                          icon: MaterialCommunityIcons.web,
                        ),
                        SizedBox(height: 16.h),
                        _buildLabel("TEAM SIZE"),
                        _buildTextField(
                          controller: teamSizeController,
                          hint: "e.g., 4",
                          icon: Icons.group,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        _buildLabel("DURATION (IN MONTHS)"),
                        _buildTextField(
                          controller: durationController,
                          hint: "e.g., 3",
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                        ),

                        SizedBox(height: 32.h),

                        // ── SECTION: CATEGORIES ──
                        _buildSectionHeader("CATEGORIES", Icons.category),
                        SizedBox(height: 16.h),
                        _buildCategoriesSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: TECH STACK ──
                        _buildSectionHeader("TECH STACK", Icons.code),
                        SizedBox(height: 16.h),
                        _buildTechStackSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: MEMBER NAMES ──
                        _buildSectionHeader("MEMBER NAMES", Icons.people),
                        SizedBox(height: 16.h),
                        _buildMemberNamesSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: MEMBER IDS ──
                        _buildSectionHeader("MEMBER IDs", Icons.badge),
                        SizedBox(height: 16.h),
                        _buildMemberIdsSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: IMAGES ──
                        _buildSectionHeader("IMAGES", Icons.image),
                        SizedBox(height: 16.h),
                        _buildImagesSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: VIDEO ──
                        _buildSectionHeader("VIDEO", Icons.videocam),
                        SizedBox(height: 16.h),
                        _buildVideoSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: REPORT PDF ──
                        _buildSectionHeader(
                            "PROJECT REPORT (PDF)", Icons.picture_as_pdf),
                        SizedBox(height: 16.h),
                        _buildReportSection(),

                        SizedBox(height: 32.h),

                        // ── SECTION: PPT ──
                        _buildSectionHeader(
                            "PRESENTATION (PPT)", Icons.slideshow),
                        SizedBox(height: 16.h),
                        _buildPptSection(),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),

                // ── BOTTOM: UPDATE BUTTON ──
                _buildBottomBar(),
              ],
            ),
    );
  }

  // ═══════════════════════════════════════
  // ── SECTION HEADER
  // ═══════════════════════════════════════
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: const Color(0xFF3B82F6), size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════
  // ── LABEL
  // ═══════════════════════════════════════
  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: textGrey,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // ── TEXT FIELD
  // ═══════════════════════════════════════
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    void Function(String)? onSubmitted,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2237),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: const Color(0xFF3B82F6), size: 20.sp),
          hintText: hint,
          hintStyle: TextStyle(color: textGrey, fontSize: 14.sp),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // ── CATEGORIES SECTION
  // ═══════════════════════════════════════
  Widget _buildCategoriesSection() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: availableCategories.map((cat) {
        bool isSelected = selectedCategories.contains(cat);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedCategories.remove(cat);
              } else {
                selectedCategories.add(cat);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6).withOpacity(0.2)
                  : const Color(0xFF1C2237),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : Colors.white.withOpacity(0.05),
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              cat,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3B82F6) : textGrey,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════
  // ── TECH STACK SECTION
  // ═══════════════════════════════════════
  Widget _buildTechStackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: techSearchController,
          hint: "e.g. React, Python (Press Enter to add)",
          icon: Icons.search,
          onSubmitted: (val) {
            if (val.trim().isNotEmpty && !selectedTechs.contains(val.trim())) {
              setState(() {
                selectedTechs.add(val.trim());
              });
              techSearchController.clear();
            }
          },
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: selectedTechs
              .map((tech) => Chip(
                    label: Text(tech,
                        style: const TextStyle(color: Color(0xFF3B82F6))),
                    backgroundColor: const Color(0xFF1E293B),
                    deleteIcon: const Icon(Icons.close,
                        color: Color(0xFF3B82F6), size: 16),
                    onDeleted: () {
                      setState(() {
                        selectedTechs.remove(tech);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(
                          color: const Color(0xFF3B82F6).withOpacity(0.3)),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════
  // ── MEMBER NAMES SECTION
  // ═══════════════════════════════════════
  Widget _buildMemberNamesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: memberNameInputController,
          hint: "Enter member name and press Enter",
          icon: Icons.person_add,
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              setState(() {
                memberNames.add(val.trim());
              });
              memberNameInputController.clear();
            }
          },
        ),
        SizedBox(height: 12.h),
        if (memberNames.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: memberNames.asMap().entries.map((entry) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
                  child: Text(
                    '${entry.key + 1}',
                    style: TextStyle(
                        color: const Color(0xFF3B82F6), fontSize: 10.sp),
                  ),
                ),
                label: Text(entry.value,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: const Color(0xFF1E293B),
                deleteIcon: const Icon(Icons.close,
                    color: Colors.redAccent, size: 16),
                onDeleted: () {
                  setState(() {
                    memberNames.removeAt(entry.key);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                      color: Colors.white.withOpacity(0.1)),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════
  // ── MEMBER IDS SECTION
  // ═══════════════════════════════════════
  Widget _buildMemberIdsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: memberIdInputController,
          hint: "Enter member ID and press Enter",
          icon: Icons.badge_outlined,
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              setState(() {
                memberIds.add(val.trim());
              });
              memberIdInputController.clear();
            }
          },
        ),
        SizedBox(height: 12.h),
        if (memberIds.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: memberIds.asMap().entries.map((entry) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: const Color(0xFF3B82F6).withOpacity(0.2),
                  child: Text(
                    '${entry.key + 1}',
                    style: TextStyle(
                        color: const Color(0xFF3B82F6), fontSize: 10.sp),
                  ),
                ),
                label: Text(entry.value,
                    style: const TextStyle(color: Colors.white)),
                backgroundColor: const Color(0xFF1E293B),
                deleteIcon: const Icon(Icons.close,
                    color: Colors.redAccent, size: 16),
                onDeleted: () {
                  setState(() {
                    memberIds.removeAt(entry.key);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  side: BorderSide(
                      color: Colors.white.withOpacity(0.1)),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════
  // ── IMAGES SECTION
  // ═══════════════════════════════════════
  Widget _buildImagesSection() {
    final bool hasAnyImages =
        existingImageUrls.isNotEmpty || newLocalImages.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasAnyImages) ...[
          // Count badge
          Text(
            "${existingImageUrls.length + newLocalImages.length} image(s)",
            style: TextStyle(color: textGrey, fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),

          // Image grid
          SizedBox(
            height: 110.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Existing (network) images
                ...List.generate(existingImageUrls.length, (index) {
                  return _buildImageTile(
                    child: Image.network(
                      existingImageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.broken_image,
                        color: Colors.grey.shade600,
                        size: 30.sp,
                      ),
                    ),
                    onRemove: () => _removeExistingImage(index),
                    isNetwork: true,
                  );
                }),

                // New (local) images
                ...List.generate(newLocalImages.length, (index) {
                  return _buildImageTile(
                    child: Image.file(
                      File(newLocalImages[index]),
                      fit: BoxFit.cover,
                    ),
                    onRemove: () => _removeNewImage(index),
                    isNetwork: false,
                  );
                }),

                // Add button
                _buildAddImageButton(),
              ],
            ),
          ),
        ] else ...[
          // Empty state — just show add
          GestureDetector(
            onTap: _pickNewImages,
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: const Color(0xFF161B2E),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate,
                      color: const Color(0xFF3B82F6), size: 32.sp),
                  SizedBox(height: 8.h),
                  Text(
                    "Add Images",
                    style: TextStyle(
                      color: const Color(0xFF3B82F6),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageTile({
    required Widget child,
    required VoidCallback onRemove,
    required bool isNetwork,
  }) {
    return Container(
      width: 110.w,
      height: 110.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isNetwork
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFF3B82F6).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            // Badge
            if (!isNetwork)
              Positioned(
                bottom: 6,
                left: 6,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "NEW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            // Remove button
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close,
                      color: Colors.white, size: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickNewImages,
      child: Container(
        width: 110.w,
        height: 110.h,
        decoration: BoxDecoration(
          color: const Color(0xFF161B2E),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,
                color: const Color(0xFF3B82F6), size: 28.sp),
            SizedBox(height: 4.h),
            Text(
              "Add",
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // ── VIDEO SECTION
  // ═══════════════════════════════════════
  Widget _buildVideoSection() {
    // New local video takes precedence
    if (newLocalVideo != null) {
      return _buildMediaCard(
        icon: Icons.videocam,
        label: newLocalVideo!.split('/').last,
        isNew: true,
        onRemove: _removeVideo,
        onReplace: _pickNewVideo,
      );
    }

    if (existingVideoUrl.isNotEmpty) {
      return _buildMediaCard(
        icon: Icons.videocam,
        label: _extractFilename(existingVideoUrl),
        isNew: false,
        onRemove: _removeVideo,
        onReplace: _pickNewVideo,
      );
    }

    return _buildEmptyMediaPicker(
      icon: Icons.videocam,
      label: "Add Video",
      onTap: _pickNewVideo,
    );
  }

  // ═══════════════════════════════════════
  // ── REPORT SECTION
  // ═══════════════════════════════════════
  Widget _buildReportSection() {
    if (newLocalReport != null) {
      return _buildMediaCard(
        icon: Icons.picture_as_pdf,
        label: newLocalReport!.split('/').last,
        isNew: true,
        onRemove: _removeReport,
        onReplace: _pickNewReport,
      );
    }

    if (existingReportUrl.isNotEmpty) {
      return _buildMediaCard(
        icon: Icons.picture_as_pdf,
        label: _extractFilename(existingReportUrl),
        isNew: false,
        onRemove: _removeReport,
        onReplace: _pickNewReport,
      );
    }

    return _buildEmptyMediaPicker(
      icon: Icons.picture_as_pdf,
      label: "Add Report PDF",
      onTap: _pickNewReport,
    );
  }

  // ═══════════════════════════════════════
  // ── PPT SECTION
  // ═══════════════════════════════════════
  Widget _buildPptSection() {
    if (newLocalPpt != null) {
      return _buildMediaCard(
        icon: Icons.slideshow,
        label: newLocalPpt!.split('/').last,
        isNew: true,
        onRemove: _removePpt,
        onReplace: _pickNewPpt,
      );
    }

    if (existingPptUrl.isNotEmpty) {
      return _buildMediaCard(
        icon: Icons.slideshow,
        label: _extractFilename(existingPptUrl),
        isNew: false,
        onRemove: _removePpt,
        onReplace: _pickNewPpt,
      );
    }

    return _buildEmptyMediaPicker(
      icon: Icons.slideshow,
      label: "Add Presentation",
      onTap: _pickNewPpt,
    );
  }

  // ═══════════════════════════════════════
  // ── MEDIA CARD (existing or new file)
  // ═══════════════════════════════════════
  Widget _buildMediaCard({
    required IconData icon,
    required String label,
    required bool isNew,
    required VoidCallback onRemove,
    required VoidCallback onReplace,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2237),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isNew
              ? const Color(0xFF3B82F6).withOpacity(0.5)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 22.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    if (isNew)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.h),
                        margin: EdgeInsets.only(right: 6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "NEW",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Text(
                      "Tap replace to change",
                      style:
                          TextStyle(color: textGrey, fontSize: 10.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Replace button
          GestureDetector(
            onTap: onReplace,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "Replace",
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.redAccent, size: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  // ── EMPTY MEDIA PICKER
  // ═══════════════════════════════════════
  Widget _buildEmptyMediaPicker({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFF161B2E),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // ── BOTTOM BAR
  // ═══════════════════════════════════════
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF10121A),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: _handleUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, color: Colors.white, size: 20.sp),
                SizedBox(width: 10.w),
                Text(
                  "Update Project",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  // ── HELPERS
  // ═══════════════════════════════════════
  String _extractFilename(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        // Cloudinary URLs often have the filename as last segment
        String last = segments.last;
        // Remove extension prefix if Cloudinary adds version
        if (last.contains('.')) {
          return last;
        }
        return last;
      }
    } catch (_) {}
    return url.length > 30 ? '${url.substring(0, 30)}...' : url;
  }
}