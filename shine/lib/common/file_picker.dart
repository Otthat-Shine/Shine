// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:filesaverz/filesaverz.dart' as filesaverz;

class FilePicker {
  static Future<List<File>?> pickFiles({
    required BuildContext context,
    String? title,
    List<String>? allowedExtensions,
  }) async {
    switch (Platform.operatingSystem) {
      case "windows":
        file_picker.FilePickerResult? selectedFiles =
            await file_picker.FilePicker.platform.pickFiles(
          allowMultiple: true,
          dialogTitle: title,
          allowedExtensions: allowedExtensions,
        );

        if (selectedFiles == null) return null;
        return selectedFiles.paths.map((path) => File(path!)).toList();
      case "android":
        List<File>? selectedFiles = await filesaverz.FileSaver(
          fileTypes: allowedExtensions,
          initialDirectory: Directory('/storage/emulated/0'),
        ).pickFiles(context);

        if (selectedFiles == null || selectedFiles.isEmpty) return null;
        return selectedFiles;
      default:
        throw FilePickerException("Unsupported platform");
    }
  }

  static Future<File?> pickSignalFile({
    required BuildContext context,
    String? title,
    List<String>? allowedExtensions,
  }) async {
    switch (Platform.operatingSystem) {
      case "windows":
        file_picker.FilePickerResult? selectedFile =
            await file_picker.FilePicker.platform.pickFiles(
          dialogTitle: title,
          allowedExtensions: allowedExtensions,
        );

        if (selectedFile == null) return null;
        return File(selectedFile.paths.first!);
      case "android":
        File? selectedFile = await filesaverz.FileSaver(
          fileTypes: allowedExtensions,
          initialDirectory: Directory('/storage/emulated/0'),
        ).pickFile(context);

        return selectedFile;
      default:
        throw FilePickerException("Unsupported platform");
    }
  }

  static Future<Directory?> getDirectoryPath({String? title}) async {
    String? dir = await file_picker.FilePicker.platform.getDirectoryPath(
      dialogTitle: title,
    );

    if (dir == null) return null;
    return Directory(dir);
  }
}

class FilePickerException implements Exception {
  final String _msg;

  FilePickerException(this._msg);

  @override
  String toString() {
    return 'FilePickerException: $_msg';
  }
}
