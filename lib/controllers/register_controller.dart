import 'package:app/models/success_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../constants/links.dart';
import '../models/api_error_model.dart';

class RegisterController extends GetxController{
  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading =>_isLoading.value;

  set setLoading(bool newState){
    _isLoading.value = newState;
  }

  void registerFunction(String data) async{
    setLoading = true;

    Uri url =Uri.parse(registerUrl);

    Map<String, String> headers = {'Content-Type': 'application/json'};

    try{
      var response = await http.post(
          url, headers: headers, body: data
      );

      if(response.statusCode == 1){

        var data = successModelFromJson(response.body);

        setLoading = false;

        Get.back();

        Get.snackbar(
            "You successfully registered", data.message,
            colorText: kLightWhite,
            backgroundColor: Colors.green,
            icon: const Icon(Ionicons.airplane_sharp)
        );


      }else{
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
            "Failed to register", error.message,
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