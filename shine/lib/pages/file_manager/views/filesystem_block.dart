// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:shine/common/dialogs.dart';
import 'package:shine/routes/app_pages.dart';
import '../controllers/file_manager_controller.dart';

class FileSystemBlock extends GetView<FileManagerController> {
  const FileSystemBlock(
      {super.key, required this.entity, required this.icon, this.color});

  final FileSystemEntity entity;
  final Icon icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final stat = entity.statSync();

    return GestureDetector(
      onLongPressStart: (details) {
        onLongPressStart(context, details);
      },
      child: ListTile(
        title: Text(p.basename(entity.path)),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Date: ${stat.modified.toString()}',
              style: const TextStyle(fontSize: 10),
            ),
            const Text('\t'),
            stat.type != FileSystemEntityType.directory
                ? Text(
                    'Size: ${(stat.size / 1024 / 1024).ceil()} MB',
                    style: const TextStyle(fontSize: 10),
                  )
                : const Text(''),
          ],
        ),
        tileColor: color,
        leading: icon,
        onTap: onTap,
      ),
    );
  }

  void onTap() async {
    if (!entity.existsSync()) {
      Dialogs.error('No such file or directory.');
      return;
    }

    switch (entity.statSync().type) {
      case FileSystemEntityType.directory:
        Get.toNamed(
          AppRoutes.fileManager,
          preventDuplicates: false,
          arguments: {'path': entity.path},
        );
        break;
      case FileSystemEntityType.file:
        openFile();
      default:
    }
  }

  void onLongPressStart(BuildContext context, LongPressStartDetails details) {
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
      PopupMenuItem(child: const Text('Rename'), onTap: () => rename(context)),
      PopupMenuItem(child: const Text('Delete'), onTap: () => delete(context)),
    ];
  }

  void openFile() {
    if (entity.path.isVideoFileName) {
      playVideo(entity.path);
    }
  }

  void playVideo(String path) {
    Get.toNamed(AppRoutes.videoPlayer, parameters: {'path': path});
  }

  Future<void> rename(BuildContext context) async {
    final results = await Dialogs.textInput(context,
        title: 'Rename', hintText: 'new name...');

    if (results.isEmpty) return;

    try {
      controller.rename(results.first.trim(), entity);
    } catch (e) {
      Dialogs.error(e.toString());
    }

    controller.refresh();
  }

  Future<void> delete(BuildContext context) async {
    try {
      await Dialogs.check(
        'Delete',
        'Are you sure you want to delete this file?',
        onConfirm: () {
          controller.delete(entity);
          controller.refresh();
        },
      );
    } catch (e) {
      Dialogs.error(e.toString());
    }
  }
}
