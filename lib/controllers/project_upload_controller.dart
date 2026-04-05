import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/links.dart';

class ProjectUploadController extends GetxController {
  var currentStep = 0.obs;

  // Step 1: Basic Info
  final titleController = TextEditingController();
  final taglineController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final List<String> availableCategories = ["AI", "ML", "IoT", "App", "Web", "Blockchain", "Others"];
  var selectedCategories = <String>[].obs;

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  // Step 2: Media Assets (local paths)
  var selectedImages = <String>[].obs;
  var selectedVideo = ''.obs;
  var selectedReport = ''.obs;
  var selectedPpt = ''.obs;

  // Cloudinary URLs (after upload)
  var uploadedImageUrls = <String>[].obs;
  var uploadedVideoUrl = ''.obs;
  var uploadedReportUrl = ''.obs;
  var uploadedPptUrl = ''.obs;

  // Upload state
  RxBool _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  RxString uploadStatus = ''.obs;

  final ImagePicker _picker = ImagePicker();

  // ==============================
  // ✅ UPLOAD TO CLOUDINARY
  // ==============================
  Future<String?> uploadToCloudinary(String filePath, String resourceType) async {
    try {
      Uri url = Uri.parse("$cloudinaryUploadUrl");

      var request = http.MultipartRequest("POST", url);
      request.fields['upload_preset'] = cloudinaryUploadPreset;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['secure_url'];
      } else {
        debugPrint("Cloudinary upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Cloudinary upload error: $e");
      return null;
    }
  }

  // ==============================
  // ✅ UPLOAD ALL FILES TO CLOUDINARY
  // ==============================
  Future<bool> uploadAllToCloudinary() async {
    _isUploading.value = true;

    try {
      // Upload images
      uploadedImageUrls.clear();
      for (int i = 0; i < selectedImages.length; i++) {
        uploadStatus.value = "Uploading image ${i + 1}/${selectedImages.length}...";
        String? url = await uploadToCloudinary(selectedImages[i], "image");
        if (url != null) {
          uploadedImageUrls.add(url);
        } else {
          Get.snackbar("Upload Failed", "Failed to upload image ${i + 1}",
              backgroundColor: Colors.redAccent, colorText: Colors.white);
          _isUploading.value = false;
          uploadStatus.value = '';
          return false;
        }
      }

      // Upload video
      uploadStatus.value = "Uploading video...";
      String? videoUrl = await uploadToCloudinary(selectedVideo.value, "video");
      if (videoUrl != null) {
        uploadedVideoUrl.value = videoUrl;
      } else {
        Get.snackbar("Upload Failed", "Failed to upload video",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        _isUploading.value = false;
        uploadStatus.value = '';
        return false;
      }

      // Upload report PDF
      uploadStatus.value = "Uploading report...";
      String? reportUrl = await uploadToCloudinary(selectedReport.value, "raw");
      if (reportUrl != null) {
        uploadedReportUrl.value = reportUrl;
      } else {
        Get.snackbar("Upload Failed", "Failed to upload report",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        _isUploading.value = false;
        uploadStatus.value = '';
        return false;
      }

      // Upload PPT
      uploadStatus.value = "Uploading presentation...";
      String? pptUrl = await uploadToCloudinary(selectedPpt.value, "raw");
      if (pptUrl != null) {
        uploadedPptUrl.value = pptUrl;
      } else {
        Get.snackbar("Upload Failed", "Failed to upload presentation",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        _isUploading.value = false;
        uploadStatus.value = '';
        return false;
      }

      uploadStatus.value = "All files uploaded!";
      _isUploading.value = false;
      return true;
    } catch (e) {
      debugPrint("Upload all error: $e");
      _isUploading.value = false;
      uploadStatus.value = '';
      return false;
    }
  }

  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      selectedImages.addAll(images.map((e) => e.path));
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      selectedVideo.value = video.path;
    }
  }

  Future<void> pickReport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf']
      );
      if (result != null && result.files.single.path != null) {
        selectedReport.value = result.files.single.path!;
      }
    } catch (e) {
      print("Error picking report: \$e");
    }
  }

  Future<void> pickPpt() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'ppt', 'pptx']
      );
      if (result != null && result.files.single.path != null) {
        selectedPpt.value = result.files.single.path!;
      }
    } catch (e) {
      print("Error picking ppt: \$e");
    }
  }

  // Step 3: Tech Stack & Links
  final techSearchController = TextEditingController();
  var selectedTechs = <String>['React'].obs;
  final repoUrlController = TextEditingController();
  final demoLinkController = TextEditingController();

  // Step 4: Final Review Editable Fields
  final teamSizeController = TextEditingController();
  final durationController = TextEditingController();
  final memberNameController = TextEditingController();
  final memberIdController = TextEditingController();

  void nextStep() {
    if (currentStep.value == 0) {
      if (titleController.text.trim().isEmpty || 
          taglineController.text.trim().isEmpty || 
          descriptionController.text.trim().isEmpty ||
          selectedCategories.isEmpty) {
        Get.snackbar("Required Fields", "Please fill all the basic info fields and select at least one category.", backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    } else if (currentStep.value == 1) {
      if (selectedImages.isEmpty || selectedVideo.value.isEmpty || selectedReport.value.isEmpty || selectedPpt.value.isEmpty) {
        Get.snackbar("Required Media", "Images, Video, Report, and PPT are all required.", backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    } else if (currentStep.value == 2) {
      if (selectedTechs.isEmpty || repoUrlController.text.trim().isEmpty) {
        Get.snackbar("Required Fields", "Please select at least one tech and provide a repository URL.", backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    }

    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void addTech(String tech) {
    if (tech.trim().isNotEmpty && !selectedTechs.contains(tech.trim())) {
      selectedTechs.add(tech.trim());
      techSearchController.clear();
    }
  }

  void removeTech(String tech) {
    selectedTechs.remove(tech);
  }

  void removeImage(String path) {
    selectedImages.remove(path);
  }

  void clearAll() {
    titleController.clear();
    taglineController.clear();
    descriptionController.clear();
    selectedCategories.clear();

    selectedImages.clear();
    selectedVideo.value = '';
    selectedReport.value = '';
    selectedPpt.value = '';

    uploadedImageUrls.clear();
    uploadedVideoUrl.value = '';
    uploadedReportUrl.value = '';
    uploadedPptUrl.value = '';

    techSearchController.clear();
    selectedTechs.clear();
    selectedTechs.add('React');
    repoUrlController.clear();
    demoLinkController.clear();

    teamSizeController.clear();
    durationController.clear();
    memberNameController.clear();
    memberIdController.clear();

    currentStep.value = 0;
    uploadStatus.value = '';
    _isUploading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    taglineController.dispose();
    descriptionController.dispose();
    techSearchController.dispose();
    repoUrlController.dispose();
    demoLinkController.dispose();
    teamSizeController.dispose();
    durationController.dispose();
    memberNameController.dispose();
    memberIdController.dispose();
    super.onClose();
  }
}
