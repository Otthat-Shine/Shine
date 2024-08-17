import 'dart:io';

import 'log.dart';

export 'log.dart';

class BuildAPK {
  BuildAPK._();

  static void checkEnvironments() {
    checkEnvironmentVariableExists('ANDROID_HOME');
  }

  static void prepare() {
    log.i('Flutter Clean');
    run('flutter', ['clean'], workingDirectory: './shine');

    log.i('Delete concert/android/.cxx');
    final cxxDir = Directory('./concert/android/.cxx');
    if (cxxDir.existsSync()) cxxDir.deleteSync(recursive: true);
  }

  static void build({required String version}) {
    log.i('Build for Android');
    // arm64_v8a, armeabi_v7a
    run(
      'flutter',
      ['build', 'apk', '--release', '--split-per-abi'],
      workingDirectory: './shine',
    );

    // universal
    run('flutter', ['build', 'apk', '--release'], workingDirectory: './shine');

    final arm64_v8a =
        File('./shine/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk');
    final armeabi_v7a = File(
        './shine/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk');
    final universal =
        File('./shine/build/app/outputs/flutter-apk/app-release.apk');

    if (!arm64_v8a.existsSync() ||
        !armeabi_v7a.existsSync() ||
        !universal.existsSync()) {
      throw WorkflowsException('Build failed: Failed to find .apk file.');
    }

    log.i('Copy files to `build/android`');
    Directory('./build/android').createSync(recursive: true);
    arm64_v8a.copySync('./build/android/shine-$version-android-arm64-v8a.apk');
    armeabi_v7a
        .copySync('./build/android/shine-$version-android-armeabi-v7a.apk');
    universal.copySync('./build/android/shine-$version-android-universal.apk');
  }
}

class BuildWinExe {
  BuildWinExe._();

  static void checkEnvironments() {
    checkProgramExists('7z', []);
  }

  static void prepare() {
    log.i('Flutter Clean');
    run('flutter', ['clean'], workingDirectory: './shine');
  }

  static void build({required String targetArch, required String version}) {
    log.i('Build for Windows');
    run('flutter', ['build', 'windows', '--release'],
        workingDirectory: './shine');

    log.i('Compress build outputs to `build/windows`');
    Directory('./build/windows/').createSync(recursive: true);
    run('7z', [
      'a',
      '-tzip',
      './build/windows/shine-$version-windows-$targetArch-portable.zip',
      './shine/build/windows/$targetArch/runner/Release/*'
    ]);
  }
}

void run(String executable, List<String> args,
    {bool print = false,
    bool exitIfFailed = true,
    bool runInShell = true,
    String? workingDirectory}) {
  log.i('Run command: $executable ${args.join(' ')}');

  try {
    ProcessResult result = Process.runSync(
      executable,
      args,
      runInShell: runInShell,
      workingDirectory: workingDirectory,
    );

    if (print) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    }

    if (result.exitCode != 0) {
      if (exitIfFailed) {
        throw WorkflowsException(
            'Command run failure. exitCode: ${result.exitCode}');
      }
      log.e(
        'Process run failure. exitCode: ${result.exitCode}',
      );
    }
  } catch (e, s) {
    if (exitIfFailed) {
      throw WorkflowsException('Command run failure.');
    }
    log.e("Command run failure", error: e, stackTrace: s);
  }
}

void checkProgramExists(String executable, List<String> args,
    {bool print = false, bool runInShell = true, String? workingDirectory}) {
  try {
    ProcessResult result = Process.runSync(
      executable,
      args,
      runInShell: runInShell,
      workingDirectory: workingDirectory,
    );

    if (print) {
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    }

    if (result.exitCode != 0) {
      throw WorkflowsException('$executable exists, but exitCode is not 0.');
    }

    log.t('Checked Program: $executable');
  } catch (e) {
    throw WorkflowsException('$executable does not exists.');
  }
}

void checkEnvironmentVariableExists(String name) {
  String variable = Platform.environment[name] ?? "";

  if (variable.isEmpty) {
    throw WorkflowsException('$name does not exist');
  }

  log.t('Checked $name: $variable');
}

class WorkflowsException implements Exception {
  final String msg;

  WorkflowsException(this.msg);

  @override
  String toString() {
    return 'WorkflowsException: $msg';
  }
}
