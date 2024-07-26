// Package imports:
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:shine/common/device_info.dart';
import 'package:shine/common/general_dialog.dart';

class PermissionManager {
  final Set<PermissionWrapper> _permissions;
  String? feature;

  PermissionManager(this._permissions, {this.feature});

  Future<void> requestAll() async {
    await GeneralDialog.checkDialog(
      'Permission',
      '''
In order to use ${feature ?? 'this function'} normally, please give the following permissions:

${_permissions.join('\n')}
    ''',
      onConfirm: () async {
        for (var e in _permissions) {
          await e.request();
        }
      },
    );
  }
}

abstract class PermissionWrapper {
  final Permission permission;
  final bool required;

  PermissionWrapper({required this.permission, this.required = true});

  Future<void> request();
}

class AndroidPermissionWrapper extends PermissionWrapper {
  final int minSdkVersion;

  AndroidPermissionWrapper({
    required super.permission,
    super.required = true,
    this.minSdkVersion = 0,
  });

  @override
  Future<void> request() async {
    if (AndroidDeviceInfo.sdkVersion < minSdkVersion) return;
    final status = await permission.request();

    switch (status) {
      case PermissionStatus.denied:
        await _onDenied();
        break;
      case PermissionStatus.permanentlyDenied:
        await _onPermanentlyDenied();
        break;
      default:
        break;
    }
  }

  Future<void> _onDenied() async {
    if (!required) return;
    await GeneralDialog.checkDialog(
      'Permission',
      'You must give ${toString()}, otherwise you cannot use this feature.',
      onConfirm: () async {
        await permission.request();
      },
    );
  }

  Future<void> _onPermanentlyDenied() async {
    if (!required) return;
    GeneralDialog.errorDialog(
        '''You must give ${toString()}, otherwise you cannot use this feature.''');
  }

  @override
  String toString() {
    // TODO: implement toString
    return permission.toString();
  }
}
