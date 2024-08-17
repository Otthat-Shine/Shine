import 'package:args/command_runner.dart';

import 'package:workflows/workflows.dart' as w;

class WindowsCommand extends Command {
  @override
  String get name => 'windows';

  @override
  String get description => 'Build for Windows Platform.';

  WindowsCommand() {
    argParser.addOption(
      'target-arch',
      help: 'Build Target arch.',
      defaultsTo: 'x64',
    );

    argParser.addOption(
      'version',
      help: 'Build Version.',
      mandatory: true,
    );
  }

  @override
  void run() {
    String targetArch = argResults!['target-arch'];
    String version = argResults!['version'];

    if (targetArch != 'x64' && targetArch != 'arm64') {
      throw w.WorkflowsException(
          'Build failed: target-arch must be x64 or arm64');
    }

    w.BuildWinExe.checkEnvironments();
    w.BuildWinExe.prepare();
    w.BuildWinExe.build(targetArch: targetArch, version: version);
  }
}
