// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:shine/common/file_picker_wrapper.dart';
import 'package:shine/common/general_dialog.dart';
import 'package:shine/generated/assets.dart';
import 'package:shine/generated/pubspec.dart';
import 'package:shine/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shine'),
        actions: const [
          _OtherOptions(),
        ],
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

class _OtherOptions extends StatelessWidget {
  const _OtherOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => options(context),
      icon: const Icon(Icons.dehaze),
    );
  }

  List<PopupMenuEntry> options(BuildContext context) {
    return [
      PopupMenuItem(
        child: const Text('About'),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return const About();
              });
        },
      ),
    ];
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: 'Shine',
      applicationVersion: 'version: ${Pubspec.version.canonical}',
      applicationIcon: Image.asset(Assets.appIcon, width: 60),
      children: const [
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: '''
「阳光」 之下无君子
「谐乐」 之上无圣贤
在你打开之时，你已然踏上一条不归之路，这里没有互通立交，有的只是通向平行之路的一条匝道。
'''),
              TextSpan(text: '务必三思而后行。', style: TextStyle(color: Colors.red)),
            ],
          ),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
