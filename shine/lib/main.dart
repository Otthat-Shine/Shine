import 'dart:io';

import 'package:concert/gen/concert.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:concert/concert.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Zip Test"),
        ),
        body: ZipTest(),
      ),
    );
  }
}

class ZipTest extends StatefulWidget {
  const ZipTest({super.key});

  @override
  State<ZipTest> createState() => _ZipTestState();
}

class _ZipTestState extends State<ZipTest> {
  final Concert _concert = Concert();

  String before = "";
  String after = "";

  void _testZip() async {
    String currentPath;
    if (Platform.isWindows) {
      currentPath = dirname(Platform.resolvedExecutable);
    } else if (Platform.isAndroid) {
      currentPath = (await getApplicationDocumentsDirectory()).path;
    } else {
      throw "Unsupported Platform";
    }

    final test_file = File("$currentPath/1.txt")..writeAsStringSync('Zip Test222');
    setState(() {
      before = test_file.readAsStringSync();
    });
    _concert.func.ZipCompress(
        '$currentPath/1.txt'.toCStr(),
        '$currentPath/1.zip'.toCStr(),
        BitCompressionMethodCopy,
        BitCompressionLevelNone,
        '12345678'.toCStr());
    test_file.deleteSync();
    _concert.func.ZipExtract('$currentPath/1.zip'.toCStr(),
        currentPath.toCStr(), '12345678'.toCStr());

    setState(() {
      after = test_file.readAsStringSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Press button to test",
          style: TextStyle(fontSize: 40),
        ),
        ElevatedButton(
          onPressed: _testZip,
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(100, 100)),
          ),
          child: const Icon(
            Icons.check,
            size: 50,
          ),
        ),
        Text(
          "Before:\n$before",
          style: const TextStyle(fontSize: 30),
        ),
        Text(
          'After:\n$after',
          style: const TextStyle(fontSize: 30),
        ),
      ],
    );
  }
}
