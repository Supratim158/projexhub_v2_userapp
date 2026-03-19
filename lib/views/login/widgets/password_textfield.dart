import 'package:app/common/app_style.dart';
import 'package:app/constants/constants.dart';
import 'package:app/controllers/password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PasswordTextfield extends StatelessWidget {
  const PasswordTextfield({super.key, this.controller});


  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final passController = Get.put(PasswordController());
    return Obx(() =>
        TextFormField(
          cursorColor: textGrey,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          controller: controller,
          obscureText: passController.password,
          validator: (value){
            if(value!.isNotEmpty){
              return "This Field is required ";
            }else{
              return null;
            }
          },
          style: appStyle(16, textWhite, FontWeight.normal),
          decoration: InputDecoration(
            filled: true,
            fillColor: cardBackground,
            hintText: "Enter your password",
            prefixIcon: Icon(CupertinoIcons.lock_circle, size: 22,color: textGrey,),
            suffixIcon: GestureDetector(
              onTap:(){
                passController.setPassword = !passController.password;
              },
              child: Icon(
                passController.password ?
                Icons.visibility
                : Icons.visibility_off,
                size: 22,color: textGrey,),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,   // increase height
              horizontal: 17,
            ),
            hintStyle: appStyle(15, textGrey.withOpacity(0.5), FontWeight.normal),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kRed,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimary,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kRed,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kGray,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: kPrimary,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimary,width: .5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
          ),
        )
    );
  }
}
