// Dart imports:
import 'dart:io';
import 'dart:isolate';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/common/concert.dart';
import 'package:shine/common/permission_manager.dart';

class HomeController extends GetxController {
  PermissionManager? pm;

  HomeController() {
    if (Platform.isAndroid) {
      pm = PermissionManager({
        AndroidPermissionWrapper(permission: Permission.storage),
        AndroidPermissionWrapper(
            permission: Permission.manageExternalStorage, minSdkVersion: 29),
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
    List<FileSystemEntity> files,
    File dest,
    String password,
  ) async {
    bool result = await Isolate.run(() {
      bool result = concert.create(
        files.map((v) => v.path).toList(),
        dest.path,
        password,
      );
      return result;
    });
    if (!result) throw HomeException('Failed to create concert file');
  }

  Future<void> extractConcertFile(
    File src,
    Directory dest,
    String password,
  ) async {
    dest.createSync(recursive: true);

    bool result = await Isolate.run(() {
      bool result = concert.extract(src.path, dest.path, password);
      return result;
    });
    if (!result) throw HomeException('Failed to extract concert file');
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
