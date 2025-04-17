import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:minecraft_controller/src/constants/asset_constants.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';
import 'package:minecraft_controller/src/constants/font_style_constants.dart';
import 'package:minecraft_controller/src/enums/keys_enum.dart';
import 'package:minecraft_controller/src/network/udp_controller.dart';

class ControllerScreen extends StatefulWidget {
  final String address;

  const ControllerScreen({
    super.key,
    required this.address,
  });

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  final udpController = UdpController();
  int selectedIndex = 0;

  final keyToAssetMap = {
    KeysEnum.attack: AssetConstants.attack,
    KeysEnum.jump: AssetConstants.jump,
    KeysEnum.sneak: AssetConstants.sneak,
    KeysEnum.up: AssetConstants.arrowUp,
    KeysEnum.down: AssetConstants.arrowDown,
    KeysEnum.left: AssetConstants.arrowLeft,
    KeysEnum.right: AssetConstants.arrowRight,
  };

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    udpController.init(serverAddress: widget.address);
  }

  @override
  void dispose() {
    super.dispose();
    udpController.dispose();
  }

  Widget arrowWidget() {
    const padding = 3.0;
    const inPadding = 5.0;
    const size = 60.0;
    return Column(
      spacing: padding,
      children: [
        _buildButton(
          keyEnum: KeysEnum.up,
          padding: inPadding,
          size: size,
        ),
        Row(
          spacing: padding,
          children: [
            _buildButton(
              keyEnum: KeysEnum.left,
              padding: inPadding,
              size: size,
            ),
            _buildButton(
              keyEnum: KeysEnum.sneak,
              padding: inPadding,
              size: size,
            ),
            _buildButton(
              keyEnum: KeysEnum.right,
              padding: inPadding,
              size: size,
            )
          ],
        ),
        _buildButton(
          keyEnum: KeysEnum.down,
          padding: inPadding,
          size: size,
        ),
      ],
    );
  }

  Widget _buildButton({
    required KeysEnum keyEnum,
    double size = 55.0,
    double padding = 0,
    Widget? widget,
    bool disabled = false,
  }) {
    return AbsorbPointer(
      absorbing: disabled,
      child: GestureDetector(
        onTapUp: (_) => udpController.sendAction(keyEnum, isSinglePress: true),
        onLongPressStart: (_) =>
            udpController.sendAction(keyEnum, isLongPress: true),
        onLongPressUp: () => udpController.sendAction(keyEnum),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Container(
            height: size,
            width: size,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: keyToAssetMap.containsKey(keyEnum)
                  ? AssetImage(keyToAssetMap[keyEnum]!)
                  : AssetImage(AssetConstants.blankButton),
            )),
            child: widget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: _buildButton(
                  keyEnum: KeysEnum.inventory,
                  disabled: true,
                  size: 40,
                  widget: Image.asset(
                    AssetConstants.back,
                  )
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 25,
            child: arrowWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 40,
                child: _buildButton(
                  keyEnum: KeysEnum.pause,
                  size: 40,
                  widget: Icon(
                    Icons.pause,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            child: _ItemSelectionBar(
              onTap: (int index) {
                udpController.sendAction(
                  KeysEnum.values[6 + index],
                  isSinglePress: true,
                );
                if (index != 9) {
                  setState(() {
                    selectedIndex = index;
                  });
                }
              },
              selectedIndex: selectedIndex,
            ),
          ),
          Positioned(
            bottom: 290,
            right: 160,
            child: _buildButton(
              keyEnum: KeysEnum.use,
              widget: Icon(
                Icons.ads_click,
                size: 28,
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: 220,
            child: _buildButton(
              keyEnum: KeysEnum.attack,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 240,
            child: _buildButton(
              keyEnum: KeysEnum.jump,
            ),
          ),
          Positioned(
            bottom: 70,
            right: 12,
            child: Joystick(
              includeInitialAnimation: false,
              base: JoystickBase(
                decoration: JoystickBaseDecoration(
                  drawArrows: false,
                  drawInnerCircle: false,
                  drawMiddleCircle: true,
                  drawOuterCircle: false,
                  middleCircleColor: Colors.grey.withValues(alpha: 0.05),
                  boxShadowColor: Colors.transparent,
                ),
              ),
              stick: JoystickStick(
                decoration: JoystickStickDecoration(
                  color: ColorConstants.grey,
                  shadowColor: Colors.transparent,
                ),
              ),
              listener: (details) {
                udpController.sendAction(
                  KeysEnum.mouseDrag,
                  x: details.x,
                  y: details.y,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemSelectionBar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const _ItemSelectionBar({
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    const size = 40.0;
    List<Widget> buttons = List.generate(10, (index) {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          height: size,
          width: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == selectedIndex ? Colors.white : Colors.transparent,
            image: DecorationImage(
              image: AssetImage(AssetConstants.hotBar),
              fit: BoxFit.contain,
            ),
          ),
          child: index == 9
              ? Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                )
              : Text(
                  "${index + 1}",
                  style: FontStylesConstants.font14(),
                ),
        ),
      );
    });

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      ),
    );
  }
}
