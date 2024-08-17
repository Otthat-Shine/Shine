import 'package:args/command_runner.dart';

import 'android.dart';
import 'windows.dart';

class BuildCommand extends Command {
  @override
  String get name => 'build';

  @override
  String get description => 'Build.';

  BuildCommand() {
    addSubcommand(WindowsCommand());
    addSubcommand(AndroidCommand());
  }

  @override
  void run() {}
}
