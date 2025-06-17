import 'package:flutter/material.dart';
import '../../config/app_color.dart';
import 'button_widget.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  bool isConfirm = false,
  bool barrierDismissible = true,
  required VoidCallback onConfirm,
  String cancelText = 'Batal',
  String confirmText = 'Hapus',
  Color cancelColor = AppColor.royalBlue,
  Color confirmColor = AppColor.error,
}) async {
  await showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content!),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        actions: [
          Column(
            children: [
              if (isConfirm)
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: cancelText,
                        backgroundColor: cancelColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ButtonWidget(
                        text: confirmText,
                        backgroundColor: confirmColor,
                        onPressed: () {
                          onConfirm();
                        },
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: 'OK',
                        backgroundColor: AppColor.primaryColor,
                        onPressed: () {
                          onConfirm();
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
            ],
          ),
        ],
      );
    },
  );
}
