// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/pages/file_manager/controllers/file_manager_controller.dart';
import 'filesystem_block.dart';

class FileSystemList extends GetView<FileManagerController> {
  const FileSystemList({super.key, required this.entities});

  final List<FileSystemEntity> entities;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        primary: true,
        itemBuilder: itemBuilder,
        itemCount: entities.length,
      ),
    );
  }

  Widget? itemBuilder(BuildContext context, int index) {
    if (entities.isEmpty) return null;

    return FileSystemBlock(
      entity: entities[index],
      icon: getIcon(entities[index]),
    );
  }

  Icon getIcon(FileSystemEntity fse) {
    Icon icon;

    switch (fse.statSync().type) {
      case FileSystemEntityType.file:
        icon = const Icon(Icons.article_outlined);
        break;
      case FileSystemEntityType.directory:
        icon = const Icon(Icons.folder);
        break;
      case FileSystemEntityType.link:
        icon = const Icon(Icons.link);
        break;
      case FileSystemEntityType.pipe:
        icon = const Icon(Icons.more_horiz);
        break;
      default:
        icon = const Icon(Icons.article_outlined);
    }

    return icon;
  }
}
