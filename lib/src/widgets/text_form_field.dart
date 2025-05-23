import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minecraft_controller/src/constants/color_constants.dart';
import 'package:minecraft_controller/src/constants/font_style_constants.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? title;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onChanged,
    this.validator,
    this.title,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
    Tween<double>(begin: 1.0, end: 0.0).animate(_blinkController);
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  OutlineInputBorder _outLineBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: ColorConstants.grey2,
          width: 2,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.title!,
              style: FontStylesConstants.font18(),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          autocorrect: false,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: TextInputType.number,
          style: FontStylesConstants.font18(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[0-9.]'),
            ),
          ],
          decoration: InputDecoration(
            errorStyle: FontStylesConstants.font14(
              color: ColorConstants.red,
            ),
            border: _outLineBorder(),
            errorBorder: _outLineBorder(),
            enabledBorder: _outLineBorder(),
            focusedBorder: _outLineBorder(),
            disabledBorder: _outLineBorder(),
            focusedErrorBorder: _outLineBorder(),
          ),
        ),
      ],
    );
  }
}
