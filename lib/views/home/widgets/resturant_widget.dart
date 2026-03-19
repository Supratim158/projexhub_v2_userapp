import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';

class ResturantWidget extends StatelessWidget {
  const ResturantWidget({
    super.key, 
    required this.image, 
    required this.logo, 
    required this.title, 
    required this.time, 
    required this.rating, 
    this.onTap});

  final String image;
  final String logo;
  final String title;
  final String time;
  final String rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 192.h,
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
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: SizedBox(
                      height: 112.h,
                      width: width*.8,
                      child: Image.asset(image, fit: BoxFit.fitWidth,),
                    ),
                  ),

                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        color: kLightWhite,
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(logo, fit: BoxFit.cover,height: 20.h,width: 20.w,) ,
                          ),
                        ),
                      ),
                    )
                    ),
                ],
              ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: title, 
                      style: appStyle(12, kDark, FontWeight.w500)
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                      text: "Open", 
                      style: appStyle(9, kGray, FontWeight.w500)
                    ),

                    ReusableText(
                      text: time, 
                      style: appStyle(9, kDark, FontWeight.w500)
                    ),
                      ],
                    ),

                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 5,
                          itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber,),
                          itemCount: 5,
                          itemSize: 15.h,
                        ),
                        SizedBox(width: 10.w,),
                        ReusableText(
                          text: "$rating+ revies and ratings", 
                          style: appStyle(9, kGray, FontWeight.w500)
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