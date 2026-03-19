import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';

class UserInfoWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;
  final VoidCallback onEdit;

  const UserInfoWidget({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgDark2,
      ),
      child: Stack(
        children: [

          /// Main Profile Content
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [


                /// 🔹 Profile Image
                CircleAvatar(
                  radius: 45.r,
                  backgroundImage: AssetImage(imagePath),
                ),

                SizedBox(width: 10.h),

                /// 🔹 Name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(text: name, style: appStyle(18, textWhite, FontWeight.w600)),
                    ReusableText(text: email, style: appStyle(11, textGrey, FontWeight.normal)),
                  ],
                ),

                SizedBox(width: 60.h),

                GestureDetector(
                  onTap: (){},
                  child: Icon(
                    // AntDesign.edit,
                    Ionicons.create_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}