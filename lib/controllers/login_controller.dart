import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/constants/links.dart';
import 'package:app/models/login_response.dart';
import 'package:app/views/entrypoint.dart';
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
          Get.offAll(() => MainScreen(),
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
    Get.offAll(() => LoginRedirect(),
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
}