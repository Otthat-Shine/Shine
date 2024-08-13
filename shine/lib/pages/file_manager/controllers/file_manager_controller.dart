// Dart imports:
import 'dart:io';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:shine/routes/app_pages.dart';

enum SortType { name, date, size }

enum SortOrder { asc, desc }

extension on List<FileSystemEntity> {
  List<FileSystemEntity> sortBy(SortType sortType, SortOrder sortOrder) {
    if (isEmpty) return this;

    switch (sortType) {
      case SortType.name:
        sort((a, b) {
          return p
              .basename(a.path)
              .toLowerCase()
              .compareTo(p.basename(b.path).toLowerCase());
        });
        break;
      case SortType.date:
        sort((a, b) {
          return a
              .statSync()
              .modified
              .millisecondsSinceEpoch
              .compareTo(b.statSync().modified.millisecondsSinceEpoch);
        });
        break;
      case SortType.size:
        sort((a, b) {
          return a.statSync().size.compareTo(b.statSync().size);
        });
        break;
      default:
        return this;
    }

    if (sortOrder == SortOrder.desc) {
      return reversed.toList();
    }

    return this;
  }
}

class FileManagerController extends GetxController {
  String currentPath = '';
  final List<String> _history = [];
  SortType sortType = SortType.name;
  SortOrder sortOrder = SortOrder.asc;

  // Concert extension
  bool enableConcert = false;
  File? concertFile;
  Directory? concertExtDir;

  Future<List<FileSystemEntity>> getEntities() async {
    final dir = Directory(currentPath);

    if (!(await dir.exists())) {
      throw FileManagerException('Directory does not exist.');
    }

    List<FileSystemEntity> entities = await dir.list().toList();
    var dirEntities = entities
        .where((element) => FileSystemEntity.isDirectorySync(element.path))
        .toList();

    var fileEntities = entities
        .where((element) => !FileSystemEntity.isDirectorySync(element.path))
        .toList();

    dirEntities = dirEntities.sortBy(sortType, sortOrder);
    fileEntities = fileEntities.sortBy(sortType, sortOrder);

    return dirEntities + fileEntities;
  }

  void updateFileSystemList() {
    update(['FileSystemList']);
  }

  void addHistory(String path) => _history.add(path);

  void removeLastHistory() => _history.removeLast();

  bool get isHistoryEmpty => _history.isEmpty;

  String get lastHistory => _history.last;

  void newFile(String name) async {
    if (name.isEmpty) {
      throw FileManagerException('Empty name.');
    }

    if (name.contains(RegExp(r'[\/:*?"<>|]'))) {
      throw FileManagerException('Illegal name.');
    }

    File newFile = File(p.join(currentPath, name));

    await newFile.create();
  }

  void newFolder(String name) async {
    if (name.isEmpty) {
      throw FileManagerException('Empty name.');
    }

    if (name.contains(RegExp(r'[\/:*?"<>|]'))) {
      throw FileManagerException('Illegal name.');
    }

    Directory newDir = Directory(p.join(currentPath, name));

    await newDir.create();
  }

  void rename(String newName, FileSystemEntity entity) async {
    if (!entity.existsSync()) {
      throw FileManagerException('No such file or directory.');
    }

    if (newName.isEmpty) {
      throw FileManagerException('Empty name.');
    }

    if (newName.contains(RegExp(r'[\/:*?"<>|]'))) {
      throw FileManagerException('Illegal name.');
    }

    await entity.rename(p.join(currentPath, newName));
  }

  void delete(FileSystemEntity entity) async {
    if (!entity.existsSync()) {
      throw FileManagerException('No such file or directory.');
    }

    await entity.delete(recursive: true);
  }

  void playVideo(String path) {
    Get.toNamed(AppRoutes.videoPlayer, parameters: {'path': path});
  }
}

class FileManagerException implements Exception {
  final String msg;

  FileManagerException(this.msg);

  @override
  String toString() {
    return 'FileManagerException: $msg';
  }
}
