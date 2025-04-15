import 'package:flutter/material.dart';
import 'package:minecraft_controller/src/constants/asset_constants.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';
import 'package:minecraft_controller/src/constants/font_style_constants.dart';
import 'package:minecraft_controller/src/utils/audio_utils.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const borderSide = BorderSide(
      width: 2,
      color: Colors.transparent,
    );
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          FocusManager.instance.primaryFocus?.unfocus();
          AudioUtils.buttonSound();
          onPressed!();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
          border: onPressed == null
              ? Border(
                  top: borderSide,
                  left: borderSide,
                  right: borderSide,
                  bottom: borderSide,
                )
              : Border(
                  top: borderSide.copyWith(
                    color: ColorConstants.btnWhite,
                  ),
                  left: borderSide.copyWith(
                    color: ColorConstants.btnWhite,
                  ),
                  right: borderSide.copyWith(
                    color: ColorConstants.btnGrey,
                  ),
                  bottom: borderSide.copyWith(
                    color: ColorConstants.btnGrey,
                  ),
                ),
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              onPressed == null
                  ? AssetConstants.skinDark
                  : AssetConstants.skinLight,
            ),
          ),
        ),
        child: Text(
          text,
          style: FontStylesConstants.font16(),
        ),
      ),
    );
  }
}
