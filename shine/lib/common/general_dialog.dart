// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:get/get.dart';

class GeneralDialog {
  static void warningDialog(String content) {
    Get.defaultDialog(
      title: 'Warning',
      content: Text(content),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  static void errorDialog(String content) {
    Get.defaultDialog(
      title: 'Error',
      content: Text(content),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  static void checkDialog(
    String title,
    String content, {
    void Function()? onConfirm,
    void Function()? onCancel,
  }) {
    Get.defaultDialog(
      title: title,
      content: Text(content),
      confirm: ElevatedButton(
        onPressed: () {
          if (onConfirm != null) {
            onConfirm();
          }
          Get.back();
        },
        child: const Text('OK'),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('Cancel'),
      ),
    );
  }

  static Future<List<String>> openTextInputDialog(
    BuildContext context, {
    required String title,
    required String hintText,
  }) async {
    List<String> results = await showTextInputDialog(
          context: context,
          textFields: [DialogTextField(hintText: hintText)],
          title: title,
          autoSubmit: true,
        ) ??
        [];

    return results;
  }
}
