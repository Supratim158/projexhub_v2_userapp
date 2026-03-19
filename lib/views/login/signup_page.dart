import 'package:app/controllers/register_controller.dart';
import 'package:app/models/register_model.dart';
import 'package:app/views/login/signin_page.dart';
import 'package:app/views/login/widgets/animated_button.dart';
import 'package:app/views/login/widgets/email_textfield.dart';
import 'package:app/views/login/widgets/password_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../common/app_style.dart';
import '../../common/bg_controller.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: kDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDark,
        title: ReusableText(text: "Projexhub", style: appStyle(20, textWhite, FontWeight.normal),),
        centerTitle: true,
      ),
      body: BgController(
          color: kDark,
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Lottie.asset("assets/anime/lottie.json"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                EmailTextfield(
                  hintText: "Enter your name",
                  prefixIcon: const Icon(CupertinoIcons.profile_circled, size: 22,color: textGrey,),
                  controller: _nameController,
                ),

                SizedBox(height: 25.h,),

                EmailTextfield(
                  hintText: "Enter your email",
                  prefixIcon: Icon(CupertinoIcons.mail, size: 22,color: textGrey,),
                  controller: _emailController,
                ),

                SizedBox(height: 25.h,),

                PasswordTextfield(
                  controller: _passwordController,
                ),
                SizedBox(height: 6.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: (){
                          Get.to(() => SigninPage(),
                              transition: Transition.leftToRightWithFade,
                              duration: Duration(milliseconds: 700));
                        },
                        child: ReusableText(text: "Login", style: appStyle(15, textWhite, FontWeight.normal))),
                  ],
                ),
                SizedBox(height: 15.h,),

                AnimatedButton(
                    text: "CREATE",
                    onTap: (){
                      if(_nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.length >= 6){
                        RegisterModel model = RegisterModel(
                            userName: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text);

                        String data = registerModelToJson(model);

                        //register function
                        controller.registerFunction(data);
                      };
                    }
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
