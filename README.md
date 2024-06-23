# Shine

<img src="shine/assets/images/app_icon.png" width=300></img>

**Shine**是一款可视化**文件加解密**工具，**Concert**是本项目的重要组成部分。

## 特性

1. 可以对多个文件进行**加解密**操作
2. 具有一个简单的**文件管理器**
3. 内置**视频播放器**，可以播放常见视频文件
4. 支持Android & Windows平台

## 下载方式

[Releases](https://github.com/Otthat-Shine/Shine/releases)

## 技术架构

Shine使用Flutter跨平台框架构建用户界面，对于核心的加解密操作则由Concert完成。

Shine使用Dart FFI技术在上层调用Concert；Concert使用`libsodium`对文件加解密、使用`bit7z`对文件打包。

本项目还使用到了[build_7zip_for_android](https://github.com/patryyyy/build_7zip_for_android)项目。

## 第三方库

Shine:

| 第三方库                                                     | 协议                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons)  | [MIT](https://pub.dev/packages/cupertino_icons/license)      |
| [path_provider](https://pub.dev/packages/path_provider)      | [BSD-3-Clause](https://pub.dev/packages/path_provider/license) |
| [path](https://pub.dev/packages/path)                        | [BSD-3-Clause](https://pub.dev/packages/path/license)        |
| [get](https://pub.dev/packages/get)                          | [MIT](https://pub.dev/packages/get/license)                  |
| [adaptive_dialog](https://pub.dev/packages/adaptive_dialog)  | [MIT](https://pub.dev/packages/adaptive_dialog/license)      |
| [file_picker](https://pub.dev/packages/file_picker)          | [MIT](https://pub.dev/packages/file_picker/license)          |
| [uuid](https://pub.dev/packages/uuid)                        | [MIT](https://pub.dev/packages/uuid/license)                 |
| [permission_handler](https://pub.dev/packages/permission_handler) | [MIT](https://pub.dev/packages/permission_handler/license)   |
| [device_info_plus](https://pub.dev/packages/device_info_plus) | [BSD-3-Clause](https://pub.dev/packages/device_info_plus/license) |
| [open_file_manager](https://pub.dev/packages/open_file_manager) | [MIT](https://pub.dev/packages/open_file_manager/license)    |
| [flutter_easyloading](https://pub.dev/packages/flutter_easyloading) | [MIT](https://pub.dev/packages/flutter_easyloading/license)  |
| [filesaverz](https://pub.dev/packages/filesaverz)            | [MIT](https://pub.dev/packages/filesaverz/license)           |
| [video_player](https://pub.dev/packages/video_player)        | [BSD-3-Clause](https://pub.dev/packages/video_player/license) |
| [video_player_win](https://pub.dev/packages/video_player_win) | [BSD-3-Clause](https://pub.dev/packages/video_player_win/license) |
| [video_player_control_panel](https://pub.dev/packages/video_player_control_panel) | [BSD-3-Clause](https://pub.dev/packages/video_player_control_panel/license) |
| [flutter_lints](https://pub.dev/packages/flutter_lints)      | [BSD-3-Clause](https://pub.dev/packages/flutter_lints/license) |
| [import_sorter](https://pub.dev/packages/import_sorter)      | [MIT](https://pub.dev/packages/import_sorter/license)        |
| [pubspec_generator](https://pub.dev/packages/pubspec_generator) | [MIT](https://pub.dev/packages/pubspec_generator/license)    |
| [build_runner](https://pub.dev/packages/build_runner)        | [BSD-3-Clause](https://pub.dev/packages/build_runner/license) |

Concert:

- Dart

| 第三方库                                                     | 协议                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [ffi](https://pub.dev/packages/ffi)                          | [BSD-3-Clause](https://pub.dev/packages/ffi/license)         |
| [plugin_platform_interface](https://pub.dev/packages/plugin_platform_interface) | [BSD-3-Clause](https://pub.dev/packages/plugin_platform_interface/license) |
| [uuid](https://pub.dev/packages/uuid)                        | [MIT](https://pub.dev/packages/uuid/license)                 |
| [flutter_lints](https://pub.dev/packages/flutter_lints)      | [BSD-3-Clause](https://pub.dev/packages/flutter_lints/license) |
| [ffigen](https://pub.dev/packages/ffigen)                    | [BSD-3-Clause](https://pub.dev/packages/ffigen/license)      |

- C/C++

| 第三方库                                                     | 协议                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [otthat_libsodium](https://github.com/Otthat-Shine/otthat_libsodium) | [ISC License](https://github.com/jedisct1/libsodium/blob/master/LICENSE) |
| [otthat_bit7z](https://github.com/Otthat-Shine/otthat_bit7z) | [Mozilla Public License 2.0](https://github.com/rikyoz/bit7z/blob/master/LICENSE) |

## 许可证

[Mozilla Public License 2.0](LICENSE)

