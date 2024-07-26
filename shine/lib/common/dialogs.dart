// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:get/get.dart';

class Dialogs {
  static Future<void> warning(String content, {bool readonly = false}) async {
    await Get.defaultDialog(
      title: 'Warning',
      content: readonly ? Text(content) : SelectableText(content),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  static Future<void> error(String content, {bool readonly = false}) async {
    await Get.defaultDialog(
      title: 'Error',
      content: readonly ? Text(content) : SelectableText(content),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }

  static Future<void> check(
    String title,
    String content, {
    void Function()? onConfirm,
    void Function()? onCancel,
    bool readonly = false,
  }) async {
    await Get.defaultDialog(
      title: title,
      content: readonly ? Text(content) : SelectableText(content),
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

  static Future<List<String>> textInput(
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
