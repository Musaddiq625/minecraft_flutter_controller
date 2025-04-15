import 'package:flutter/material.dart';
import 'package:minecraft_controller/src/constants/app_constants.dart';
import 'package:minecraft_controller/src/constants/asset_constants.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';
import 'package:minecraft_controller/src/constants/font_style_constants.dart';
import 'package:minecraft_controller/src/screens/start_menu_screen.dart';
import 'package:minecraft_controller/src/utils/audio_utils.dart';
import 'package:minecraft_controller/src/utils/dev_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showFlutterImage = false;
  bool showControllerImage = false;
  bool showMineCraftImage = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      insertOverlay();
      await Future.delayed(Duration(milliseconds: 600))
          .then((_) => setState(() => showFlutterImage = true));
      await AudioUtils.placeBlockSound();
      await Future.delayed(Duration(milliseconds: 600))
          .then((_) => setState(() => showControllerImage = true));
      await AudioUtils.placeBlockSound();
      await Future.delayed(Duration(milliseconds: 200))
          .then((_) => setState(() => showMineCraftImage = true));
      await AudioUtils.placeBlockSound();
      Future.delayed(
        Duration(milliseconds: 1500),
        () => Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (_) => StartMenuScreen(),
          ),
        ),
      );
    });
    super.initState();
  }

  void insertOverlay() {
    final ValueNotifier<bool> showDialog = ValueNotifier(true);
    Overlay.of(context).insert(OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: 20,
        width: 110,
        top: size.height - 40,
        left: size.width - 130,
        child: ValueListenableBuilder(
            valueListenable: showDialog,
            builder: (context, _, __) {
              return Visibility(
                visible: showDialog.value,
                child: GestureDetector(
                  onTap: () async {
                    DevDialog.show(context).then((_) async {
                      showDialog.value = true;
                    });
                    showDialog.value = false;
                  },
                  child: Text(
                    AppConstants.dev,
                    style: FontStylesConstants.font14(
                      color: ColorConstants.white,
                    ),
                  ),
                ),
              );
            }),
       );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          child: Row(
            spacing: 40,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetConstants.controllerPixelLogo,
                scale: 3,
                color: showControllerImage ? null : Colors.transparent,
              ),
              Image.asset(
                AssetConstants.flutterPixelLogo,
                color: showFlutterImage ? null : Colors.transparent,
              ),
              Image.asset(
                AssetConstants.minecraftBlockPixelLogo,
                scale: 2,
                color: showMineCraftImage ? null : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
