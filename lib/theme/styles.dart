import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';

class AppButtonStyles {
  static final outlined = TextButton.styleFrom(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: AppColors.medGrey),
      borderRadius: BorderRadiusGeometry.all(Radius.circular(40.0)),
    ),
    foregroundColor: AppColors.black,
    textStyle: TextStyle(fontFamily: "Poppins"),
    padding: EdgeInsets.symmetric(horizontal: 20.0),
  );

  static final filled = TextButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    textStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600),
    padding: EdgeInsets.symmetric(horizontal: 20.0),
  );

  static final text = TextButton.styleFrom(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.primary,
    textStyle: TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
    ),
  );
}
