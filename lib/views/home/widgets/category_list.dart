import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/uidata.dart';
import '../../../controllers/category_controller.dart';
import '../../category/all_categories.dart';
import 'category_items.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Container(
      height: 75.h,
      padding: EdgeInsets.only(top: 10.h, left: 12.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(categories.length, (i){
          var category = categories[i];
          return CategoryItem(category: category,);
        }),
      ),
    );
  }
}
