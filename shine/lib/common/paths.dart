// Package imports:
import 'package:path_provider/path_provider.dart';

class Paths {
  static Future<String> get appRoot async {
    return (await getApplicationSupportDirectory()).path;
  }
}
