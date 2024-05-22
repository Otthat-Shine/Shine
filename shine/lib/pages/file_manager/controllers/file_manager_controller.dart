// Dart imports:
import 'dart:io';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

enum SortType { name, date, size }

enum SortOrder { asc, desc }

extension on List<FileSystemEntity> {
  List<FileSystemEntity> sortBy(SortType sortType, SortOrder sortOrder) {
    if (isEmpty) return this;

    switch (sortType) {
      case SortType.name:
        sort((a, b) {
          return p.basename(a.path).compareTo(p.basename(b.path).toLowerCase());
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
  String? _rootPath;
  String? _previousPath;
  String? _currentPath;

  List<FileSystemEntity> _dirEntities = [];
  List<FileSystemEntity> _fileEntities = [];
  final _entities = <FileSystemEntity>[].obs;

  final _sortType = SortType.name.obs;
  final _sortOrder = SortOrder.asc.obs;

  set currentPath(value) => _currentPath = value;

  get currentPath => _currentPath;

  set previousPath(value) => _previousPath = value;

  get previousPath => _previousPath;

  set entities(value) => _entities.value = value;

  get entities => _entities.toList();

  set dirEntities(value) => _dirEntities = value;

  get dirEntities => _dirEntities;

  set fileEntities(value) => _fileEntities = value;

  get fileEntities => _fileEntities;

  set sortType(value) => _sortType.value = value;

  get sortType => _sortType.value;

  set sortOrder(value) => _sortOrder.value = value;

  get sortOrder => _sortOrder.value;

  void getEntities() {
    if (currentPath == null) return;

    final dir = Directory(_currentPath!);

    if (!dir.existsSync()) {
      throw FileManagerException('Directory does not exist.');
    }

    List<FileSystemEntity> entities = dir.listSync();
    try {
      _dirEntities = entities
          .where((element) => FileSystemEntity.isDirectorySync(element.path))
          .toList();

      _fileEntities = entities
          .where((element) => !FileSystemEntity.isDirectorySync(element.path))
          .toList();

      sort();

      _entities.value = _dirEntities + _fileEntities;
    } catch (e) {}
  }

  void sort() {
    _dirEntities = _dirEntities.sortBy(_sortType.value, _sortOrder.value);
    _fileEntities = _fileEntities.sortBy(_sortType.value, _sortOrder.value);

    _entities.value = _dirEntities + _fileEntities;
  }

  void newFile(String newName) {
    final path = currentPath;

    if (newName.isEmpty) {
      throw FileManagerException('Empty name.');
    }

    if (newName.contains(RegExp(r'[\/:*?"<>|]'))) {
      throw FileManagerException('Illegal name.');
    }

    File newFile = File(p.join(path, newName));

    newFile.createSync();
  }

  void newFolder(String newName) {
    final path = currentPath;

    if (newName.isEmpty) {
      throw FileManagerException('Empty name.');
    }

    if (newName.contains(RegExp(r'[\/:*?"<>|]'))) {
      throw FileManagerException('Illegal name.');
    }

    Directory newDir = Directory(p.join(path, newName));

    newDir.createSync();
  }

  void rename(String newName, FileSystemEntity entity) {
    final path = currentPath;

    if (!entity.existsSync()) {
      throw FileManagerException('No such file or directory.');
    }

    if (newName.isEmpty) {
      throw FileManagerException('Empty name.');
    }

    if (newName.contains(RegExp(r'[\/:*?"<>|]'))) {
      throw FileManagerException('Illegal name.');
    }

    entity.renameSync(p.join(path, newName));
  }

  void delete(FileSystemEntity entity) {
    if (!entity.existsSync()) {
      throw FileManagerException('No such file or directory.');
    }

    entity.deleteSync(recursive: true);
  }

  @override
  void refresh() {
    entities.clear();
    getEntities();
    super.refresh();
  }
}

class FileManagerException implements Exception {
  final String msg;

  FileManagerException(this.msg);

  @override
  String toString() {
    return '$FileManagerException: $msg';
  }
}
