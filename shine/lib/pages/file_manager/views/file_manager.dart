// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/common/general_dialog.dart';
import '../controllers/file_manager_controller.dart';
import 'filesystem_list.dart';

class FileManager extends GetView<FileManagerController> {
  const FileManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['path']),
        actions: [
          otherOptions(),
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
    );
  }

  Widget otherOptions() {
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
      controller.newFile(results.first);
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
      controller.newFolder(results.first);
    } catch (e) {
      GeneralDialog.errorDialog(e.toString());
    }

    controller.refresh();
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
