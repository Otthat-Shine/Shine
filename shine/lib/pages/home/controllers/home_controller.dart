// Dart imports:
import 'dart:io';
import 'dart:isolate';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/common/concert.dart';
import 'package:shine/common/permission_manager.dart';

class HomeController extends GetxController {
  String? _extractionPath;
  String? _concertFilePath;
  PermissionManager? pm;

  set extractionPath(value) => _extractionPath = value;

  get extractionPath => _extractionPath;

  set concertFilePath(value) => _concertFilePath = value;

  get concertFilePath => _concertFilePath;

  HomeController() {
    if (Platform.isAndroid) {
      pm = PermissionManager({
        AndroidPermissionWrapper(permission: Permission.storage),
        AndroidPermissionWrapper(permission: Permission.manageExternalStorage, minSdkVersion: 29),
      }, feature: 'Create/Read Concert File');
    }
  }

  @override
  void onReady() async {
    super.onReady();

    // Request permissions
    if (pm != null) await pm!.requestAll();
  }

  Future<void> createConcertFile(
    List<String> files,
    String path,
    String password,
  ) async {
    bool result = await Isolate.run(() {
      bool result = concert.create(files, path, password);
      return result;
    });
    if (!result) throw HomeException('Failed to create concert file');
  }

  Future<void> extractConcertFile(
    String src,
    String dest,
    String password,
  ) async {
    Directory(dest).createSync(recursive: true);

    bool result = await Isolate.run(() {
      bool result = concert.extract(src, dest, password);
      return result;
    });
    if (!result) throw HomeException('Failed to extract concert file');

    _extractionPath = dest;
    _concertFilePath = src;
  }

  void clear() {
    _extractionPath = '';
    _concertFilePath = '';
  }
}

class HomeException implements Exception {
  final String msg;

  HomeException(this.msg);

  @override
  String toString() {
    return '$HomeException: $msg';
  }
}
