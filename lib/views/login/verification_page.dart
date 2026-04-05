import 'package:app/common/app_style.dart';
import 'package:app/common/bg_controller.dart';
import 'package:app/common/reusable_text.dart';
import 'package:app/constants/constants.dart';
import 'package:app/controllers/verification_controller.dart';
import 'package:app/views/login/widgets/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
    return Scaffold(
      body: BgController(
          color: kDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SizedBox(
              height: height,
              child: ListView(
                children: [
                  Lottie.asset("assets/anime/robo.json"),

                  SizedBox(height: 30.h,),
                  
                  ReusableText(text: "Verify your account", style: appStyle(23, kWhite, FontWeight.w600)),

                  SizedBox(height: 10.h,),

                  Text("Enter the 6-digit code send to your email, if you don't see the code, check on the spam folder",
                  textAlign: TextAlign.justify,
                    style: appStyle(12, kGray, FontWeight.normal),
                  ),

                  SizedBox(height: 10.h,),

                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: primaryPurple,
                    borderWidth: 2.0,
                    showFieldAsBox: true,
                    textStyle: appStyle(16, textWhite, FontWeight.w600),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    onCodeChanged: (String code) {},
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode){
                      controller.setCode = verificationCode;
                    }, // end onSubmit
                  ),

                  SizedBox(height: 20.h,),

                  AnimatedButton(text: "VERIFY", onTap: (){
                    controller.verifyFunction();
                  })
                ],
              ),
            ),
          )),
    );
  }
}
