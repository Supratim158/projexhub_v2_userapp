import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/constants/links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FeedbackController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newState) {
    _isLoading.value = newState;
  }

  // 🚀 SEND FEEDBACK FUNCTION
  Future<void> sendFeedback({
    required String title,
    required String feedback,
  }) async {
    setLoading = true;

    String? token = box.read("token");

    Uri url = Uri.parse(sendFeedbackUrl);

    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": title,
          "feedback": feedback,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setLoading = false;

        Get.snackbar(
          "Feedback Sent 🎉",
          data["message"],
          colorText: kLightWhite,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.feedback),
        );

      } else {
        setLoading = false;

        Get.snackbar(
          "Failed",
          data["message"] ?? "Something went wrong",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error_outline),
        );
      }

    } catch (e) {
      setLoading = false;
      debugPrint("Feedback Error: ${e.toString()}");

      Get.snackbar(
        "Error",
        "Something went wrong",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error_outline),
      );
    }
  }
}