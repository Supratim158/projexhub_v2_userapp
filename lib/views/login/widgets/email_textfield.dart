import 'package:app/common/app_style.dart';
import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailTextfield extends StatelessWidget {
  const EmailTextfield({super.key, this.onEditingComplete, this.keyboardType, this.initialValue, this.controller, this.hintText, this.prefixIcon});

  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: textGrey,
      textInputAction: TextInputAction.next,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      initialValue: initialValue,
      controller: controller,
      validator: (value){
        if(value!.isNotEmpty){
          return "This Field is required ";
        }else{
          return null;
        }
      },
      style: appStyle(16, textWhite, FontWeight.normal),
      decoration: InputDecoration(
        filled: true,
        fillColor: cardBackground,
        hintText: hintText,
        prefixIcon: prefixIcon,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,   // increase height
          horizontal: 17,
        ),
        hintStyle: appStyle(15, textGrey.withOpacity(0.5), FontWeight.normal),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kRed,width: .5),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimary,width: .5),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kRed,width: .5),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kGray,width: .5),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        enabledBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: kPrimary,width: .5),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimary,width: .5),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
    );
  }
}
