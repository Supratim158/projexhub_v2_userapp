import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ProjectUploadController extends GetxController {
  var currentStep = 0.obs;

  // Step 1: Basic Info
  final titleController = TextEditingController();
  final taglineController = TextEditingController();
  final descriptionController = TextEditingController();

  // Step 2: Media Assets
  var selectedImages = <String>[].obs;
  var selectedVideo = ''.obs;
  var selectedReport = ''.obs;
  var selectedPpt = ''.obs;

  final ImagePicker _picker = ImagePicker();

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
  final teamSizeController = TextEditingController(text: "4 Members");
  final durationController = TextEditingController(text: "3 Months");
  final memberNameController = TextEditingController();

  void nextStep() {
    if (currentStep.value == 0) {
      if (titleController.text.trim().isEmpty || 
          taglineController.text.trim().isEmpty || 
          descriptionController.text.trim().isEmpty) {
        Get.snackbar("Required Fields", "Please fill all the basic info fields.", backgroundColor: Colors.redAccent, colorText: Colors.white);
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
    super.onClose();
  }
}
