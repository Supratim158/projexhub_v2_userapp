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

class VerificationController extends GetxController{
  final box = GetStorage();

  String _code = "";

  String get code => _code;

  set setCode(String value){
    _code = value;
  }

  RxBool _isLoading = false.obs;

  bool get isLoading =>_isLoading.value;

  set setLoading(bool value){
    _isLoading.value = value;
  }

  void verifyFunction() async{
    setLoading = true;

    String accessToken = box.read("token");

    Uri url =Uri.parse('$verificationUrl/$code');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    try{
      var response = await http.get(
          url, headers: headers
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
            "You successfully verified", "Explore Projects",
            colorText: kLightWhite,
            backgroundColor: Colors.green,
            icon: const Icon(Ionicons.airplane_sharp)
        );

        Get.offAll(()=> const MainScreen());



      }else{
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
            "Failed to verify", error.message,
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
}