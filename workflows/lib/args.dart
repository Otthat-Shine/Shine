import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'command/export.dart';

class Args {
  static final _runner = CommandRunner('workflows', 'Github Workflows');
  static List<String> _args = [];

  static void parseArgs(List<String> args) {
    _args = args;

    _runner..addCommand(BuildCommand());

    _runner.run(args).catchError((error) {
      if (error is! UsageException) throw error;
      print(error);
      exit(64);
    });
  }

  static ArgResults get results {
    return _runner.parse(_args);
  }
}
