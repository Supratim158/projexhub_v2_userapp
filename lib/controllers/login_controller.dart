import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/constants/links.dart';
import 'package:app/models/login_response.dart';
import 'package:app/views/entrypoint.dart';
import 'package:app/views/login/signin_page.dart';
import 'package:app/views/profile/login_redirect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/api_error_model.dart';
import '../views/login/verification_page.dart';

class LoginController extends GetxController{
  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading =>_isLoading.value;

  set setLoading(bool newState){
    _isLoading.value = newState;
  }

  void loginFunction(String data) async{
    setLoading = true;

    Uri url =Uri.parse(loginUrl);

    Map<String, String> headers = {'Content-Type': 'application/json'};

    try{
      var response = await http.post(
        url, headers: headers, body: data
      );

      if(response.statusCode == 200){
        LoginResponse data = loginResponseFromJson(response.body);

        String userId = data.id;
        String userData = jsonEncode(data);

        box.write(userId, userData);
        box.write("token", data.userToken);
        box.write("userId", data.id);
        box.write("verification", data.verification);

        setLoading = false;

        Get.snackbar(
            "You successfully loggedin", "Explore Projects",
          colorText: kLightWhite,
          backgroundColor: Colors.green,
          icon: const Icon(Ionicons.airplane_sharp)
        );

        if(data.verification == false){
          Get.offAll(() => VerificationPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 900)
          );
        }

        if(data.verification == true){
          Get.offAll(() => const MainScreen(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 900)
          );
        }


      }else{
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
            "Failed to login", error.message,
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error_outline)
        );

      }
    }
    catch(e){
      debugPrint(e.toString());
    }
  }

  void logout() {
    box.erase();
    Get.offAll(() => SigninPage(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 900)
    );
  }

  LoginResponse? getUserInfo(){
    String? userId = box.read("userId");
    String? data;

    if(userId != null){
      data = box.read(userId.toString());
    }
    if(data != null){
      return loginResponseFromJson(data);
    }
    return null;
  }

  Future<void> deleteUser() async {
  setLoading = true;

  String? token = box.read("token");

  Uri url = Uri.parse(deleteUserUrl);

  try {
    var response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setLoading = false;

      // 🧹 Clear local storage
      box.erase();

      Get.snackbar(
        "Account Deleted",
        data["message"],
        colorText: kLightWhite,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.delete),
      );

      // 🚀 Redirect to login
      Get.offAll(() => SigninPage(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 900));
    } else {
      setLoading = false;

      Get.snackbar(
        "Failed",
        data["message"],
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error_outline),
      );
    }
  } catch (e) {
    setLoading = false;
    debugPrint(e.toString());
  }
}

Future<void> updateProfile({
  required String username,
  required String email,
  required String profile,
  required String role,
  required String bio,
}) async {
  setLoading = true;

  String? token = box.read("token");

  Uri url = Uri.parse(updateProfileUrl); // 👉 add this in links.dart

  try {
    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userName": username,
        "email": email,
        "profile": profile,
        "role": role,
        "bio": bio
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // ✅ Inject current token because backend _doc doesn't return userToken
      Map<String, dynamic> userMap = data["user"];
      userMap["userToken"] = token;

      // ✅ Parse updated user
      LoginResponse updatedUser = LoginResponse.fromJson(userMap);

      // ✅ Update local storage
      box.write(updatedUser.id, jsonEncode(updatedUser));
      box.write("verification", updatedUser.verification);

      setLoading = false;

      Get.snackbar(
        "Success",
        data["message"],
        colorText: kLightWhite,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check),
      );

      // 🔄 Refresh UI
      update();

    } else {
      setLoading = false;

      Get.snackbar(
        "Failed",
        data["message"] ?? "An error occurred",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error_outline),
      );
    }
  } catch (e) {
    setLoading = false;
    debugPrint("Update Profile Error: ${e.toString()}");
    Get.snackbar(
      "Error",
      "An unexpected error occurred: ${e.toString()}",
      colorText: kLightWhite,
      backgroundColor: kRed,
      icon: const Icon(Icons.error_outline),
      duration: const Duration(seconds: 4),
    );
  }
}

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  setLoading = true;

  String? token = box.read("token");

  Uri url = Uri.parse(changePasswordUrl);

  try {
    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setLoading = false;

      Get.snackbar(
        "Success 🔐",
        data["message"],
        colorText: kLightWhite,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.lock_open),
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
    debugPrint("Change Password Error: ${e.toString()}");

    Get.snackbar(
      "Error",
      "An unexpected error occurred",
      colorText: kLightWhite,
      backgroundColor: kRed,
      icon: const Icon(Icons.error_outline),
    );
  }
}
}