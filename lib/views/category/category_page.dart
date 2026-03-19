import 'package:flutter/material.dart';
import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),
        title: ReusableText(text: "Categories", style: appStyle(16, kDark, FontWeight.w600)),
        centerTitle: true,
        backgroundColor: kOffWhite,
      ),
    );
  }
}