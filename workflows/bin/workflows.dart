import 'dart:async';
import 'dart:io';

import 'package:workflows/args.dart';
import 'package:workflows/workflows.dart';

void main(List<String> arguments) {
  runZonedGuarded(() {
    _main(arguments);
  }, (e, s) {
    log.e('Fatal error occurred', error: e, stackTrace: s);
  });
}

void _main(List<String> arguments) {
  log.i(
      'Make sure that the path you are currently running is the project root');
  log.t('Current path: ${Directory.current}');

  checkGit();
  checkFlutter();

  Args.parseArgs(arguments);
}

void checkGit() {
  checkProgramExists('git', ['--version']);
}

void checkFlutter() {
  checkProgramExists('flutter', ['--version']);
}
