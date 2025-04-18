import 'package:flutter/material.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';

class FontStylesConstants {
  static final _shadows = [
    Shadow(
      color: ColorConstants.lightBlack,
      blurRadius: 4,
      offset: Offset(2, 2),
    ),
  ];

  static TextStyle font12({
    Color color = ColorConstants.white,
  }) {
    return TextStyle(
      color: color,
      fontSize: 11,
      decorationColor: color,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle font14({
    Color color = ColorConstants.white,
    bool isUnderline = false,
  }) {
    return TextStyle(
      color: color,
      fontSize: 14,
      decorationColor: color,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      shadows: _shadows,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
      fontFamily: "Minecraft Seven v2",
    );
  }

  static TextStyle font16({
    Color color = ColorConstants.white,
  }) {
    return TextStyle(
      color: color,
      fontSize: 16,
      decorationColor: color,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      shadows: _shadows,
    );
  }

  static TextStyle font18({
    Color color = ColorConstants.white,
  }) {
    return TextStyle(
      color: color,
      fontSize: 18,
      decorationColor: color,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      shadows: _shadows,
    );
  }
}
