import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';

class FoodWidget extends StatelessWidget {
  const FoodWidget({super.key, required this.image, required this.title, required this.price, required this.time, this.onTap});

  final String image;
  final String title;
  final String price;
  final String time;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180.h,
        width: width*.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: cardBackground.withOpacity(0.5),
        ),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  height: 112.h,
                  width: width*.8,
                  child: Image.asset(image, fit: BoxFit.fitWidth,),
                ),
              ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                          text: title, 
                          style: appStyle(12, kDark, FontWeight.w500)
                        ),
                        ReusableText(
                          text: "\$ $price", 
                          style: appStyle(12, kPrimary, FontWeight.w500)
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                      text: "Delivery time", 
                      style: appStyle(9, kGray, FontWeight.w500)
                    ),

                    ReusableText(
                      text: time, 
                      style: appStyle(9, kDark, FontWeight.w500)
                    ),
                      ],
                    ),

                  ],
                ),
                ),
          ],
        ),
      ));
  }
}