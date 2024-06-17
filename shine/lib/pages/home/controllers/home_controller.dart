// Dart imports:
import 'dart:io';
import 'dart:isolate';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:shine/common/concert.dart';
import '../../../common/general_dialog.dart';

class HomeController extends GetxController {
  String? _extractionPath;
  String? _concertFilePath;
  final List<Permission> _permissions = [Permission.storage];

  set extractionPath(value) => _extractionPath = value;

  get extractionPath => _extractionPath;

  set concertFilePath(value) => _concertFilePath = value;

  get concertFilePath => _concertFilePath;

  @override
  void onReady() async {
    super.onReady();

    if (Platform.isAndroid) {
      List<Permission> deniedPermissions = await checkPermissions();

      if (deniedPermissions.isNotEmpty) {
        String content = '';
        for (var e in deniedPermissions) {
          content += '\n$e\n';
        }

        await GeneralDialog.checkDialog(
          'Request permissions',
          'In order to use Shine normally, you need to give the following permissions:\n$content\nOtherwise, the program cannot be used',
          onConfirm: () async {
            await requestPermissions(deniedPermissions);
          },
          onCancel: () async {
            exit(1);
          },
        );
      }
    }
  }

  Future<void> requestPermissions(List<Permission> permissions) async {
    if (permissions.isEmpty) return;

    for (var e in permissions) {
      final status = await e.request();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied) {
        await GeneralDialog.errorDialog(
            'You have to give the $e permission, otherwise you cannot use it');
        exit(1);
      }
    }
  }

  Future<List<Permission>> checkPermissions() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    int sdkVersion = (await deviceInfo.androidInfo).version.sdkInt;

    if (sdkVersion >= 29) {
      _permissions.addAll([Permission.manageExternalStorage]);
    }

    List<Permission> deniedPermissions = [];

    for (var e in _permissions) {
      if (await e.isGranted) continue;
      deniedPermissions.add(e);
    }

    return deniedPermissions;
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
