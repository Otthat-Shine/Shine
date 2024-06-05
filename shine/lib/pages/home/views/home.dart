// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:shine/common/file_picker_wrapper.dart';
import 'package:shine/common/general_dialog.dart';
import 'package:shine/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async => await createConcertFile(context),
              child: const Text('Create Concert File'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => await extractConcertFile(context),
              child: const Text('Extract Concert File'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createConcertFile(BuildContext context) async {
    if (!context.mounted) return;
    List<String> name = await GeneralDialog.openTextInputDialog(
      context,
      title: 'What would you like to name the concert file?',
      hintText: 'name...',
    );
    if (name.isEmpty) return;

    if (!context.mounted) return;
    List<String> password = await GeneralDialog.openTextInputDialog(
      context,
      title: 'Please enter the password',
      hintText: 'password...',
      obscureText: true,
    );
    if (password.isEmpty) return;

    if (!context.mounted) return;
    List<String>? selectedFiles = await FilePickerWrapper.pickFiles(
      context: context,
      title: 'Select the files to make concert file',
    );
    if (selectedFiles == null) return;

    if (!context.mounted) return;
    String? selectedPath = await FilePickerWrapper.getDirectoryPath(
      title: 'Select a location to save the concert file',
    );
    if (selectedPath == null) return;

    EasyLoading.show(status: 'Creating...');

    try {
      await controller.createConcertFile(selectedFiles,
          p.join(selectedPath, '${name.first}.concert'), password.first);

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Create successfully');
    } catch (e) {
      EasyLoading.dismiss();
      GeneralDialog.errorDialog(e.toString());
      return;
    }
  }

  Future<void> extractConcertFile(BuildContext context) async {
    String? selectedFile = await FilePickerWrapper.pickSignalFile(
      context: context,
      title: 'Please select a concert file',
      allowedExtensions: ['.concert'],
    );
    if (selectedFile == null) return;

    if (!context.mounted) return;
    List<String> password = await GeneralDialog.openTextInputDialog(
      context,
      title: 'Please enter the password',
      hintText: 'password...',
      obscureText: true,
    );
    if (password.isEmpty) return;

    if (!context.mounted) return;
    String? selectedPath = await FilePickerWrapper.getDirectoryPath(
      title: 'Select a location to save the concert file',
    );
    if (selectedPath == null) return;

    EasyLoading.show(status: 'Extracting...');

    try {
      await controller.extractConcertFile(
          selectedFile, selectedPath, password.first);

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Extract successfully');
    } catch (e) {
      EasyLoading.dismiss();
      GeneralDialog.errorDialog(e.toString());
      return;
    }

    Get.toNamed(
      AppRoutes.fileManager,
      preventDuplicates: false,
      arguments: {'enableConcert': true, 'path': selectedPath},
    );
  }
}
