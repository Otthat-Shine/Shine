// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/pages/file_manager/controllers/file_manager_controller.dart';
import 'package:shine/widgets/shine_logo.dart';
import 'filesystem_block.dart';

class FileSystemList extends GetView<FileManagerController> {
  const FileSystemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: GetBuilder<FileManagerController>(
        id: 'FileSystemList',
        builder: (logic) {
          return FutureBuilder<List<FileSystemEntity>>(
              future: controller.getEntities(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    primary: true,
                    itemBuilder: (context, index) => itemBuilder(
                      context,
                      index,
                      snapshot.data!,
                    ),
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: SelectableText(
                      snapshot.error.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  return const Center(
                    child: ShineLogo(size: 60),
                  );
                }
              });
        },
      ),
    );
  }

  Widget? itemBuilder(
    BuildContext context,
    int index,
    List<FileSystemEntity> entities,
  ) {
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
