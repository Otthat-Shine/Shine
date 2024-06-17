// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:open_file_manager/open_file_manager.dart' as open_file_manager;

// Project imports:
import 'package:shine/common/general_dialog.dart';
import 'package:shine/pages/home/controllers/home_controller.dart';
import '../controllers/file_manager_controller.dart';
import 'filesystem_list.dart';

class FileManager extends GetView<FileManagerController> {
  const FileManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.currentPath),
        actions: [
          Offstage(
              offstage: !controller.enableConcert, child: SaveAsConcertFile()),
          const _OtherOptions(),
        ],
      ),
      body: Obx(
        () => GestureDetector(
          child: FileSystemList(entities: controller.entities),
          onTap: () {
            controller.refresh();
          },
          onLongPressStart: (details) => showContextMenu(context, details),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await openFileManager(),
        child: const Icon(Icons.open_in_new),
      ),
    );
  }

  Future<void> openFileManager() async {
    if (Platform.isWindows) {
      try {
        Process.runSync('explorer.exe', [controller.currentPath]);
      } catch (e) {
        GeneralDialog.errorDialog('Failed to open the file manager');
      }
    } else if (Platform.isAndroid) {
      bool result = await open_file_manager.openFileManager(
        androidConfig: open_file_manager.AndroidConfig(
          folderType: open_file_manager.FolderType.download,
        ),
      );

      if (!result) {
        GeneralDialog.errorDialog('Failed to open the file manager');
        return;
      }
    }
  }

  void showContextMenu(BuildContext context, LongPressStartDetails details) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: getContextMenuOptions(context),
    );
  }

  List<PopupMenuEntry> getContextMenuOptions(BuildContext context) {
    return [
      PopupMenuItem(
        child: const Text('New File'),
        onTap: () => newFile(context),
      ),
      PopupMenuItem(
        child: const Text('New Folder'),
        onTap: () => newFolder(context),
      ),
      PopupMenuItem(
        child: const Text('Refresh'),
        onTap: () => controller.refresh(),
      ),
    ];
  }

  void newFile(BuildContext context) async {
    final results = await GeneralDialog.openTextInputDialog(context,
        title: 'New File', hintText: 'new file name...');

    if (results.isEmpty) return;

    try {
      controller.newFile(results.first.trim());
    } catch (e) {
      GeneralDialog.errorDialog(e.toString());
    }

    controller.refresh();
  }

  void newFolder(BuildContext context) async {
    final results = await GeneralDialog.openTextInputDialog(context,
        title: 'New Folder', hintText: 'new folder name...');

    if (results.isEmpty) return;

    try {
      controller.newFolder(results.first.trim());
    } catch (e) {
      GeneralDialog.errorDialog(e.toString());
    }

    controller.refresh();
  }
}

class _OtherOptions extends GetView<FileManagerController> {
  const _OtherOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => getOtherOptions(),
      tooltip: 'Other Options',
      icon: const Icon(Icons.dehaze),
    );
  }

  List<PopupMenuEntry> getOtherOptions() {
    return [
      CheckedPopupMenuItem(
        value: SortType.name,
        child: const Text('Name'),
        onTap: () => setSortType(SortType.name),
      ),
      CheckedPopupMenuItem(
        value: SortType.date,
        child: const Text('Date'),
        onTap: () => setSortType(SortType.date),
      ),
      CheckedPopupMenuItem(
        value: SortType.size,
        child: const Text('Size'),
        onTap: () => setSortType(SortType.size),
      ),
      const PopupMenuDivider(height: 0),
      CheckedPopupMenuItem(
        value: SortOrder.asc,
        child: const Text('Ascending order'),
        onTap: () => setSortOrder(SortOrder.asc),
      ),
      CheckedPopupMenuItem(
        value: SortOrder.desc,
        child: const Text('Descending order'),
        onTap: () => setSortOrder(SortOrder.desc),
      ),
    ];
  }

  void setSortType(SortType sortType) {
    controller.sortType = sortType;
    controller.refresh();
  }

  void setSortOrder(SortOrder sortOrder) {
    controller.sortOrder = sortOrder;
    controller.refresh();
  }
}

class SaveAsConcertFile extends StatelessWidget {
  SaveAsConcertFile({super.key});

  final fileManagerController = Get.find<FileManagerController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await onPressed(context);
        },
        icon: const Icon(Icons.check));
  }

  Future<void> onPressed(BuildContext context) async {
    bool isOK = false;
    await GeneralDialog.checkDialog(
      'Save',
      'Do you want to save your changes?\nNote: This will save all the files in the directory',
      onConfirm: () => isOK = true,
      onCancel: () => isOK = false,
    );
    if (!isOK) return;

    String dest = '';
    String password = '';

    final extractionPath = Directory(homeController.extractionPath);
    final fileEntityList = extractionPath.listSync();

    if (!extractionPath.existsSync()) {
      GeneralDialog.errorDialog('${extractionPath.path} does not exist');
      return;
    }

    if (fileEntityList.isEmpty) {
      GeneralDialog.errorDialog('Directory is empty');
      return;
    }

    if (!File(homeController.concertFilePath).existsSync()) {
      await GeneralDialog.errorDialog(
          '${homeController.concertFilePath} does not exist');
      return;
    }

    if (!context.mounted) return;
    List<String> newPassword = await GeneralDialog.openTextInputDialog(
      context,
      title: 'Please enter the password',
      hintText: 'password...',
      obscureText: true,
    );
    if (newPassword.isEmpty) return;

    password = newPassword.first;
    dest = homeController.concertFilePath;

    List<String> files = fileEntityList.map((v) => v.path).toList();

    try {
      EasyLoading.show(status: 'Creating...');
      await homeController.createConcertFile(files, dest, password);
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Write successfully');
    } catch (e) {
      EasyLoading.dismiss();
      GeneralDialog.errorDialog(e.toString());
      return;
    }
  }
}
