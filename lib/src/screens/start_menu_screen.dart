// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minecraft_controller/src/constants/app_constants.dart';
import 'package:minecraft_controller/src/constants/asset_constants.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';
import 'package:minecraft_controller/src/constants/font_style_constants.dart';
import 'package:minecraft_controller/src/constants/string_constants.dart';
import 'package:minecraft_controller/src/enums/status_enum.dart';
import 'package:minecraft_controller/src/network/udp_controller.dart';
import 'package:minecraft_controller/src/screens/controller_screen.dart';
import 'package:minecraft_controller/src/utils/logger_utils.dart';
import 'package:minecraft_controller/src/utils/url_utils.dart';
import 'package:minecraft_controller/src/utils/validator_utils.dart';
import 'package:minecraft_controller/src/widgets/button_widget.dart';
import 'package:minecraft_controller/src/widgets/text_form_field.dart';

class StartMenuScreen extends StatefulWidget {
  const StartMenuScreen({super.key});

  @override
  State<StartMenuScreen> createState() => _StartMenuScreenState();
}

class _StartMenuScreenState extends State<StartMenuScreen> {
  UdpController udpController = UdpController();
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSubmitted = false;
  StatusEnum status = StatusEnum.pending;

  void onChanged(String value) {
    if (isSubmitted) {
      setState(() {
        isSubmitted = false;
      });
    } else {
      textController.text = textController.text.replaceAll('..', '.');
      final val = textController.text.replaceAll('..', '.');
      if (val.split('.').length >= 4) {
        String lastValue = val.split('.').sublist(3, 4).last;
        if (lastValue.length > 3) {
          lastValue = lastValue.substring(0, 3);
        }
        textController.text =
            '${val.split('.').sublist(0, 3).join('.')}.$lastValue';
        return;
      } else {
        if (value.contains('.')) {
          value = value.split('.').last;
        }
        if (value.length >= 4) {
          final cursorPos = textController.selection.baseOffset;
          final newText =
              '${val.substring(0, val.length - 1)}.${val.substring(val.length - 1)}';
          textController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset: cursorPos + 1,
            ),
          );
        }
      }
    }
  }

  String getMessage() {
    switch (status) {
      case StatusEnum.pending:
        return StringConstants.none;
      case StatusEnum.pinging:
        return StringConstants.checkingConnection;
      case StatusEnum.noInternet:
        return StringConstants.noInternet;
      case StatusEnum.connected:
        return '${StringConstants.connectedOn} ${udpController.serverAddress}';
      case StatusEnum.exception:
        return StringConstants.invalidIpOrOffline;
    }
  }

  Color getColor() {
    switch (status) {
      case StatusEnum.pending:
        return Colors.white;
      case StatusEnum.pinging:
        return Colors.white;
      case StatusEnum.noInternet:
        return Colors.red;
      case StatusEnum.connected:
        return Colors.green;
      case StatusEnum.exception:
        return Colors.red;
    }
  }

  String? validateStatus() {
    switch (status) {
      case StatusEnum.pending:
        return null;
      case StatusEnum.pinging:
        return null;
      case StatusEnum.noInternet:
        return StringConstants.noInternet;
      case StatusEnum.connected:
        return '${StringConstants.connectedOn} ${udpController.serverAddress}';
      case StatusEnum.exception:
        return StringConstants.invalidIpOrOffline;
    }
  }

  void openHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: ColorConstants.grey,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Don\'t have the server set up?\n',
                style: FontStylesConstants.font14(
                  color: getColor(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  UrlUtils.launch(AppConstants.serverSetupLink);
                },
                child: Text(
                  'Visit this link for instructions',
                  style: FontStylesConstants.font14(isUnderline: true),
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Image.asset(
            AssetConstants.dirt,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            repeat: ImageRepeat.repeat,
          ),
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormFieldWidget(
                              controller: textController,
                              enabled: status != StatusEnum.pinging,
                              onChanged: onChanged,
                              validator: (txt) => isSubmitted
                                  ? ValidatorUtils.validIP(txt)
                                  : null,
                              title: StringConstants.ipAddress,
                            ),
                          ),
                        ),
                        Padding(
                          /// Setting this padding accurately to center the button with the text field
                          padding: const EdgeInsets.only(
                            top: 37,
                          ),
                          child: ButtonWidget(
                            onPressed: status == StatusEnum.pinging
                                ? null
                                : _startPinging,
                            text: status == StatusEnum.pinging
                                ? StringConstants.pinging
                                : StringConstants.connect,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      spacing: 6,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              StringConstants.serverNote,
                              style: FontStylesConstants.font14(),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: openHelpDialog,
                              child: Icon(
                                Icons.help_outline,
                                color: ColorConstants.white,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${StringConstants.status}: ',
                              style: FontStylesConstants.font14(),
                            ),
                            Text(
                              getMessage(),
                              style: FontStylesConstants.font14(
                                color: getColor(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (status == StatusEnum.pinging)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (status == StatusEnum.connected)
                    Center(
                      child: ButtonWidget(
                        onPressed: () {
                          /// adding this to unfocus textfield of this specific context
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ControllerScreen(
                                address: textController.text,
                              ),
                            ),
                          );
                        },
                        text: StringConstants.startPlaying,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return (result.isNotEmpty && result.first.rawAddress.isNotEmpty);
    } catch (e) {
      LoggerUtils.logs('Error in _isInternetConnected: $e');
      throw SocketException(StringConstants.noInternet);
    }
  }

  void _startPinging() async {
    setState(() {
      isSubmitted = true;
    });
    try {
      if (formKey.currentState!.validate() && await _isInternetConnected()) {
        setState(() {
          status = StatusEnum.pinging;
        });
        await udpController.init(
          serverAddress: textController.text,
        );
        setState(() {
          if (udpController.isSocketReady) {
            status = StatusEnum.connected;
          } else {
            status = StatusEnum.exception;
          }
        });
      }
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
      setState(() {
        status = StatusEnum.noInternet;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${StringConstants.failedToPing} ${textController.text}: $e'),
        ),
      );
      setState(() {
        status = StatusEnum.exception;
      });
    }
  }
}
