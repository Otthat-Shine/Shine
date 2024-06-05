// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:filesaverz/filesaverz.dart' as filesaverz;

class FilePickerWrapper {
  static Future<List<String>?> pickFiles({
    required BuildContext context,
    String? title,
  }) async {
    List<String> files = [];

    if (Platform.isWindows) {
      file_picker.FilePickerResult? selectedFiles =
          await file_picker.FilePicker.platform.pickFiles(
        allowMultiple: true,
        dialogTitle: title,
      );

      if (selectedFiles != null) {
        files = selectedFiles.paths.map((path) => path!.trim()).toList();
      } else {
        return null;
      }
    } else if (Platform.isAndroid) {
      List<File>? selectedFiles =
          await filesaverz.FileSaver().pickFiles(context);

      if (selectedFiles != null && selectedFiles.isNotEmpty) {
        files = selectedFiles.map((v) => v.path.trim()).toList();
      } else {
        return null;
      }
    } else {
      throw "Unsupported platform";
    }

    return files;
  }

  static Future<String?> pickSignalFile({
    required BuildContext context,
    String? title,
    List<String>? allowedExtensions,
  }) async {
    String file = '';

    if (Platform.isWindows) {
      file_picker.FilePickerResult? selectedFile =
          await file_picker.FilePicker.platform.pickFiles(
        dialogTitle: title,
        allowedExtensions: allowedExtensions,
      );

      if (selectedFile != null) {
        file = selectedFile.files.first.path!;
      } else {
        return null;
      }
    } else if (Platform.isAndroid) {
      File? selectedFile =
          await filesaverz.FileSaver(fileTypes: allowedExtensions)
              .pickFile(context);

      if (selectedFile != null) {
        file = selectedFile.path;
      } else {
        return null;
      }
    } else {
      throw "Unsupported platform";
    }

    return file.trim();
  }

  static Future<String?> getDirectoryPath({String? title}) async {
    return await file_picker.FilePicker.platform.getDirectoryPath(
      dialogTitle: title,
    );
  }
}
