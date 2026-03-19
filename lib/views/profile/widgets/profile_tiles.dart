import 'package:app/common/app_style.dart';
import 'package:app/common/reusable_text.dart';
import 'package:app/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ProfileTiles extends StatelessWidget {
  const ProfileTiles({super.key, required this.title, required this.icon, this.onTap});

  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      onTap: onTap,
      leading: Icon(icon),
      title: ReusableText(text: title, style: appStyle(11, textGrey, FontWeight.normal)),
      trailing: title != "Settings" ? const Icon(AntDesign.right, size: 16,) : Icon(CupertinoIcons.settings_solid, size: 16,),
    );
  }
}
