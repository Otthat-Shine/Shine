// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:get/get.dart';

class GeneralDialog {
  static Future<void> warningDialog(String content) async {
    await Get.defaultDialog(
      title: 'Warning',
      content: Text(content),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  static Future<void> errorDialog(String content) async {
    await Get.defaultDialog(
      title: 'Error',
      content: Text(content),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  static Future<void> checkDialog(
    String title,
    String content, {
    void Function()? onConfirm,
    void Function()? onCancel,
  }) async {
    await Get.defaultDialog(
      title: title,
      content: Text(content),
      confirm: ElevatedButton(
        onPressed: () {
          if (onConfirm != null) onConfirm();
          Get.back();
        },
        child: const Text('OK'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          if (onCancel != null) onCancel();
          Get.back();
        },
        child: const Text('Cancel'),
      ),
    );
  }

  static Future<List<String>> openTextInputDialog(
    BuildContext context, {
    required String title,
    required String hintText,
    bool? obscureText,
  }) async {
    List<String> results = await showTextInputDialog(
          context: context,
          textFields: [
            DialogTextField(
                hintText: hintText, obscureText: obscureText ?? false)
          ],
          title: title,
          autoSubmit: true,
        ) ??
        [];

    return results;
  }
}
