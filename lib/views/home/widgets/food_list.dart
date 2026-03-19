import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/uidata.dart';
import 'food_widget.dart';

class FoodList extends StatelessWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.h,
      padding: EdgeInsets.only(top: 10.h, left: 12.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(foods.length, (i){
          var food = foods[i];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FoodWidget(
              image: food['imageUrl'], 
              title: food['title'], 
              price: food['price'].toStringAsFixed(2), 
              time: food['time']
              ),
          );
        }),
      ),
    );
  }
}