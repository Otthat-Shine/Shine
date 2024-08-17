import 'package:logger/logger.dart';

final Logger log = Logger(
  filter: ProductionFilter(),
  printer: PrettyPrinter(methodCount: 0),
);
