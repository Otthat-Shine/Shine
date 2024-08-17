import 'package:args/command_runner.dart';

import 'package:workflows/workflows.dart' as w;

class AndroidCommand extends Command {
  @override
  String get name => 'android';

  @override
  String get description => 'Build for Android Platform.';

  AndroidCommand() {
    argParser.addOption(
      'version',
      help: 'Build Version.',
      mandatory: true,
    );
  }

  @override
  void run() {
    String version = argResults!['version'];

    w.BuildAPK.checkEnvironments();
    w.BuildAPK.prepare();
    w.BuildAPK.build(version: version);
  }
}
