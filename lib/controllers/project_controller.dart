import 'dart:convert';
import 'dart:io';
import 'package:app/constants/links.dart';
import 'package:app/models/project_model.dart';
import 'package:app/models/project_response.dart';
import 'package:app/models/search_response.dart';
import 'package:app/models/api_error_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProjectController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  RxList<ProjectModel> _projects = <ProjectModel>[].obs;
  List<ProjectModel> get projects => _projects;

  RxList<ProjectResponse> _myProjects = <ProjectResponse>[].obs;
  List<ProjectResponse> get myProjects => _myProjects;

  RxList<ProjectResponse> _userProjects = <ProjectResponse>[].obs;
  List<ProjectResponse> get userProjects => _userProjects;

  RxMap<String, List<ProjectResponse>> _topProjectsByCategory =
    <String, List<ProjectResponse>>{}.obs;

  Map<String, List<ProjectResponse>> get topProjectsByCategory =>
    _topProjectsByCategory;

  RxList<dynamic> comments = [].obs;
  RxInt likeCount = 0.obs;
  RxBool isLiked = false.obs;
  

  RxList<SearchResponse> _searchResults = <SearchResponse>[].obs;
  List<SearchResponse> get searchResults => _searchResults;

  RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;

  RxString selectedCategory = "All".obs;

  List<ProjectResponse> get filteredProjects {
    if (selectedCategory.value == "All") {
      return _myProjects;
    }
    return _myProjects
        .where((p) => p.categories.contains(selectedCategory.value))
        .toList();
  }

  // ==============================
  // ✅ CREATE PROJECT (UPLOAD)
  // ==============================
  Future<void> createProject(ProjectModel project) async {
    setLoading = true;

    String? token = box.read("token");

    Uri url = Uri.parse(createProjectUrl); // define in links.dart

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(project.toJson()),
      );

      if (response.statusCode == 201) {
        ProjectModel newProject =
            ProjectModel.fromJson(jsonDecode(response.body));

        _projects.add(newProject);

        Get.snackbar(
          "Success",
          "Project uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setLoading = false;
  }

  // ==============================
  // ✅ GET ALL PROJECTS
  // ==============================
  Future<void> fetchProjects() async {
    setLoading = true;

    // String? token = box.read("token");

    Uri url = Uri.parse(allProjectsUrl); // define this

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        _myProjects.value =
            data.map((e) => ProjectResponse.fromJson(e)).toList();
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setLoading = false;
  }

  // ==============================
  // ✅ GET USER PROJECTS
  // ==============================
  Future<void> fetchMyProjects() async {
    setLoading = true;

    String? token = box.read("token");

    Uri url = Uri.parse(getProjectsUrl); // define this

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        _userProjects.value =
            data.map((e) => ProjectResponse.fromJson(e)).toList();
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setLoading = false;
  }

  // ==============================
// ✅ GET PROJECT BY ID
// ==============================
  Rx<ProjectResponse?> _selectedProject = Rx<ProjectResponse?>(null);
  ProjectResponse? get selectedProject => _selectedProject.value;

  RxBool _isFetchingProjectDetails = false.obs;
  bool get isFetchingProjectDetails => _isFetchingProjectDetails.value;

  Future<void> fetchProjectById(String projectId) async {
  _selectedProject.value = null;
  _isFetchingProjectDetails.value = true;

  String? token = box.read("token");

  Uri url = Uri.parse("$getProjectByIdUrl/$projectId");

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token"
  };

  try {
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔥 FIX: access project object properly
      final project = data['project'];

      _selectedProject.value = ProjectResponse.fromJson(project);

      // ✅ Correct mapping
      comments.value = project['comments'] ?? [];
      likeCount.value = project['likeCount'] ?? 0;

      // ✅ IMPORTANT (main fix)
      isLiked.value = data['isLiked'] ?? false;

    } else {
      var error = apiErrorFromJson(response.body);

      Get.snackbar(
        "Error",
        error.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    debugPrint("Error fetching project by ID: $e");
  }

  _isFetchingProjectDetails.value = false;
}

  // Separate list for approved projects only
  RxList<ProjectResponse> _approvedUserProjects = <ProjectResponse>[].obs;
  List<ProjectResponse> get approvedUserProjects => _approvedUserProjects;

  Future<void> fetchApprovedUserProjects() async {
    // Optional: avoid re-triggering loading state if already fetched
    if (_approvedUserProjects.isEmpty) {
      setLoading = true;
    }

    String? token = box.read("token");

    Uri url = Uri.parse(getUserApprovedProjectsUrl);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['data'] != null) {
          List data = decoded['data'];

          _approvedUserProjects.value =
              data.map((e) => ProjectResponse.fromJson(e)).toList();
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setLoading = false;
  }

  // ==============================
// 🔍 SEARCH PROJECTS
// ==============================
  void clearSearchResults() {
    _searchResults.clear();
    _isSearching.value = false;
  }

  Future<void> searchProjects(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      return;
    }

    _isSearching.value = true;

    String? token = box.read("token");

    Uri url = Uri.parse("$searchProjectsUrl$query");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        List data = [];

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded['data'] != null) {
          data = decoded['data'];
        } else if (decoded is Map && decoded['projects'] != null) {
          data = decoded['projects'];
        }

        debugPrint("🔍 Search raw response: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}");

        // Write raw JSON to file for debugging
        try {
          File('d:\\All_projects\\flutter\\projexhub\\app\\debug_response.txt').writeAsStringSync(response.body);
        } catch (e) {
          debugPrint("Failed to write debug file: $e");
        }

        _searchResults.value =
            data.map((e) => SearchResponse.fromJson(e)).toList();

        // Debug: log parsed statuses
        for (var r in _searchResults) {
          debugPrint("🔍 Parsed: '${r.title}' → status='${r.status}'");
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      Get.snackbar(
        "Search Error",
        "Failed to parse projects: ${e.toString()}",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    _isSearching.value = false;
  }

  Future<void> toggleLike(String projectId) async {
    String? token = box.read("token");

    Uri url = Uri.parse("$toggleLikeUrl/$projectId/like");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        likeCount.value = decoded['likeCount'];
        isLiked.value = decoded['liked'];

        // 🔥 update selected project
        if (_selectedProject.value != null) {
          _selectedProject.update((proj) {
            proj!.likeCount = likeCount.value;
          });
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Like Error: ${e.toString()}");
    }
  }

// ==============================
// ✏️ UPDATE PROJECT
// ==============================
Future<void> updateProject(String projectId, ProjectModel project) async {
  setLoading = true;

  String? token = box.read("token");

  Uri url = Uri.parse("$updateProjectUrl/$projectId"); // 🔥 define in links.dart

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token"
  };

  try {
    var response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // 🔥 Handle both wrapped { project: {...} } and direct response
      Map<String, dynamic> projectJson;
      if (decoded is Map && decoded.containsKey('project')) {
        projectJson = decoded['project'];
      } else {
        projectJson = decoded;
      }

      // 🔥 Normalize status to lowercase for consistent filtering
      if (projectJson['status'] != null) {
        projectJson['status'] = projectJson['status'].toString().toLowerCase();
      }

      final updated = ProjectResponse.fromJson(projectJson);

      // 🔥 update local list (my projects)
      int index = _userProjects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _userProjects[index] = updated;
        _userProjects.refresh();
      }

      // 🔥 update selected project if open
      if (_selectedProject.value?.id == projectId) {
        _selectedProject.value = updated;
      }

      Get.snackbar(
        "Updated",
        "Project updated & sent for review (Pending)",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // 🔥 Re-fetch user projects so status page is in sync
      await fetchMyProjects();

    } else {
      var error = apiErrorFromJson(response.body);

      Get.snackbar(
        "Error",
        error.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    debugPrint("Update Error: ${e.toString()}");
  }

  setLoading = false;
}

  // 👉 FETCH COMMENTS
  Future<void> fetchComments(String projectId, {bool showLoading = true}) async {
    String? token = box.read("token");

    try {
      if (showLoading) setLoading = true;

      Uri url = Uri.parse("$getCommentsUrl/$projectId/comments");

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('comments')) {
          comments.assignAll(decoded['comments']);
        } else if (decoded is List) {
          comments.assignAll(decoded);
        }
      }
    } catch (e) {
      debugPrint("Fetch Comment Error: $e");
    } finally {
      if (showLoading) setLoading = false;
    }
  }

  Future<void> addComment(String projectId, String text) async {
    String? token = box.read("token");

    Uri url = Uri.parse("$addCommentUrl/$projectId/comment");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        // Silently fetch updated comments instead of using the raw unpopulated response
        await fetchComments(projectId, showLoading: false);

        // 🔥 update selected project
        if (_selectedProject.value != null) {
          _selectedProject.update((proj) {
            proj!.comments = comments;
          });
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Comment Error: ${e.toString()}");
    }
  }

  Future<void> replyToComment(String projectId, String commentId, String text) async {
    String? token = box.read("token");

    Uri url = Uri.parse("$replyUrl/$projectId/comment/$commentId/reply");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        // Silently fetch updated comments instead of using the raw unpopulated response
        await fetchComments(projectId, showLoading: false);

        // 🔥 update selected project
        if (_selectedProject.value != null) {
          _selectedProject.update((proj) {
            proj!.comments = comments;
          });
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
          "Error",
          error.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Reply Error: ${e.toString()}");
    }
  }

  Future<void> fetchTopProjectsByCategory() async {
  setLoading = true;

  Uri url = Uri.parse(topProjectsByCategoryUrl); // 🔥 define in links.dart

  try {
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true && decoded['data'] != null) {
        Map<String, dynamic> data = decoded['data'];

        Map<String, List<ProjectResponse>> tempMap = {};

        data.forEach((category, projects) {
          tempMap[category] = (projects as List)
              .map((e) => ProjectResponse.fromJson(e))
              .toList();
        });

        _topProjectsByCategory.value = tempMap;
      }
    } else {
      var error = apiErrorFromJson(response.body);

      Get.snackbar(
        "Error",
        error.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    debugPrint("Top Projects Error: $e");
  }

  setLoading = false;
}

// ==============================
// 🗑️ DELETE PROJECT
// ==============================
Future<void> deleteProject(String projectId) async {
  setLoading = true;

  String? token = box.read("token");

  Uri url = Uri.parse("$deleteProjectUrl/$projectId"); // 🔥 add in links.dart

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token"
  };

  try {
    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // ✅ Remove from user projects list
      _userProjects.removeWhere((p) => p.id == projectId);

      // ✅ Remove from myProjects if needed
      _myProjects.removeWhere((p) => p.id == projectId);

      // ✅ Remove from approved user projects (showcase grid)
      _approvedUserProjects.removeWhere((p) => p.id == projectId);

      // ✅ If currently opened project → clear it
      if (_selectedProject.value?.id == projectId) {
        _selectedProject.value = null;
      }

      Get.snackbar(
        "Deleted",
        decoded['message'] ?? "Project deleted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } else {
      var error = apiErrorFromJson(response.body);

      Get.snackbar(
        "Error",
        error.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    debugPrint("Delete Error: ${e.toString()}");

    Get.snackbar(
      "Error",
      "Failed to delete project",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  setLoading = false;
}
}
