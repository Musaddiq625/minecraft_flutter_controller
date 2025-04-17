import 'package:flutter/material.dart';
import 'package:minecraft_controller/src/constants/app_constants.dart';
import 'package:minecraft_controller/src/constants/asset_constants.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';
import 'package:minecraft_controller/src/constants/font_style_constants.dart';
import 'package:minecraft_controller/src/utils/audio_utils.dart';
import 'package:minecraft_controller/src/utils/url_utils.dart';

class DevDialog {
  static Widget _iconWidget(String path, String link) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          UrlUtils.launch(link);
        },
        child: SizedBox(
          height: 20,
          width: 20,
          child: Image.asset(path),
        ),
      ),
    );
  }

  static Future<void> show(BuildContext context) async {
    await AudioUtils.buttonSound();
    await showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Center(
              child: Container(
                height: 290,
                width: 500,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black, width: 2),
                    top: BorderSide(color: Colors.black, width: 2),
                    bottom:
                        BorderSide(color: ColorConstants.darkGrey, width: 4),
                    right: BorderSide(color: ColorConstants.darkGrey, width: 4),
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.lightGrey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Text(AppConstants.dev),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text('X'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 450,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Container(
                                    height: 190,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image:
                                            AssetImage(AssetConstants.devPic),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    padding: const EdgeInsets.only(
                                      top: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        _iconWidget(
                                          AssetConstants.linkedin,
                                          AppConstants.linkedInLink,
                                        ),
                                        _iconWidget(
                                          AssetConstants.github,
                                          AppConstants.githubLink,
                                        ),
                                        _iconWidget(
                                          AssetConstants.globe,
                                          AppConstants.portfolioLink,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Stack(
                                children: [
                                  CustomPaint(
                                    size: Size(320, 220),
                                    // Define the size of the bubble
                                    painter: _RPSCustomPainter(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(15).copyWith(
                                      left: 50,
                                    ),
                                    height: 220,
                                    width: 320,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        AppConstants.intro,
                                        style: FontStylesConstants.font12(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1: Shadow
    Paint paintShadow = Paint()
      ..color = ColorConstants.shadowBlack // Shadow color
      ..style = PaintingStyle.fill;

    // Path for the shadow (offset to the bottom-right)
    Path pathShadow = Path();
    pathShadow.moveTo(size.width * 0.1208000 + 4,
        size.height * 0.0025000 + 4); // Offset shadow
    pathShadow.lineTo(size.width * 0.9979000 + 4,
        size.height * 0.0042500 + 4); // Offset shadow
    pathShadow.lineTo(size.width * 0.9967500 + 4,
        size.height * 0.9955000 + 4); // Offset shadow
    pathShadow.lineTo(size.width * 0.1244000 + 4,
        size.height * 0.9996667 + 4); // Offset shadow
    pathShadow.lineTo(size.width * 0.1219000 + 4,
        size.height * 0.6265833 + 4); // Offset shadow
    pathShadow.lineTo(size.width * -0.0002237 + 4,
        size.height * 0.5148020 + 4); // Offset shadow
    pathShadow.quadraticBezierTo(
        size.width * 0.0889000 + 4,
        size.height * 0.4195833 + 4,
        size.width * 0.1194000 + 4,
        size.height * 0.3822500 + 4); // Offset shadow
    pathShadow.quadraticBezierTo(
        size.width * 0.1222500 + 4,
        size.height * 0.2185833 + 4,
        size.width * 0.1208000 + 4,
        size.height * 0.0025000 + 4); // Offset shadow
    pathShadow.close();

    // Draw the shadow first
    canvas.drawPath(pathShadow, paintShadow);

    // Layer 2: Fill color for speech bubble
    Paint paintFill0 = Paint()
      ..color = ColorConstants.white // Bubble color
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    // Path for the speech bubble
    Path path0 = Path();
    path0.moveTo(size.width * 0.1208000, size.height * 0.0025000);
    path0.lineTo(size.width * 0.9979000, size.height * 0.0042500);
    path0.lineTo(size.width * 0.9967500, size.height * 0.9955000);
    path0.lineTo(size.width * 0.1244000, size.height * 0.9996667);
    path0.lineTo(size.width * 0.1219000, size.height * 0.6265833);
    path0.lineTo(size.width * -0.0002237, size.height * 0.5148020);
    path0.quadraticBezierTo(size.width * 0.0889000, size.height * 0.4195833,
        size.width * 0.1194000, size.height * 0.3822500);
    path0.quadraticBezierTo(size.width * 0.1222500, size.height * 0.2185833,
        size.width * 0.1208000, size.height * 0.0025000);
    path0.close();

    // Draw the filled speech bubble
    canvas.drawPath(path0, paintFill0);

    // Layer 3: Border color (stroke) for speech bubble
    Paint paintStroke0 = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2) // Border color with opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.bevel;

    // Draw the border around the bubble
    canvas.drawPath(path0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
