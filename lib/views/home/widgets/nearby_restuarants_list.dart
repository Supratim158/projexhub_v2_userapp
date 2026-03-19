import 'package:app/views/home/widgets/resturant_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/uidata.dart';

class NearbyRestuarantsList extends StatelessWidget {
  const NearbyRestuarantsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.h,
      padding: EdgeInsets.only(top: 10.h, left: 12.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(restaurants.length, (i){
          var restaurant = restaurants[i];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ResturantWidget(
              image: restaurant['imageUrl'], 
              logo: restaurant['logoUrl'], 
              title: restaurant['title'], 
              time: restaurant['time'], 
              rating: restaurant['ratingCount']
              ),
          );
        }),
      ),
    );
  }
}