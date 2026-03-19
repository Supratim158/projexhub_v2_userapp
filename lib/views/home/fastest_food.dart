import 'package:app/views/home/widgets/food_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_style.dart';
import '../../common/bg_controller.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../constants/uidata.dart';

class AllFastestFood extends StatelessWidget {
  const AllFastestFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTertiary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kTertiary,
        title: ReusableText(
          text: "Fastest Food", 
          style: appStyle(15, kLightWhite, FontWeight.w600)
        ),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      body: BgController(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(foods.length, (i){
              var food = foods[i];
              return Padding(
                  padding: EdgeInsets.only(top:6.h, left: 12.w, right: 12.w),
                  child: FoodTile(food: food)
              );
            }),
          ),
          color: Colors.white
      ),
    );
  }
}