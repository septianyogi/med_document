import 'package:flutter/material.dart';

import '../config/app_color.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? TextColor;
  final VoidCallback? onPressed;

  const ButtonWidget({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.TextColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: TextColor ?? AppColor.secondaryTextColor,
        ),
      ),
    );
  }
}
