import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../category/all_categories.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';
import '../../../controllers/category_controller.dart';

class CategoryItem extends StatelessWidget {

  CategoryItem({
    super.key, this.category,
  });

  var category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    return GestureDetector(
      onTap: () {
        if (controller.categoryValue == category['_id']) {
          controller.updateCategory = '';
          controller.updateTitle = '';
        }
        else if (category['title'] == 'More') {
          Get.to(
                () => const AllCategories(),
            transition: Transition.zoom,
            duration: const Duration(milliseconds: 500),
          );
        }
        else {
          controller.updateCategory = category['_id'];
          controller.updateTitle = category['title'];
        }
      },
      child: Obx(
            () => Container(
          margin: EdgeInsets.only(right: 7.w),
          padding: EdgeInsets.only(top: 4.h),
          width: width * .19,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: controller.categoryValue == category['_id']
                  ? textGrey
                  : chipBackground,
              width: .5.w,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 35.h,
                child: Image.asset(
                  category['imageUrl'],
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5,),
              ReusableText(
                text: category['title'],
                style: appStyle(12, textWhite, FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
