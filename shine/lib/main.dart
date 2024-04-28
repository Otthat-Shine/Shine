import 'dart:io';

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
          title: const Text("Aes Encrypt/Decrypt Test"),
        ),
        body: AesTest(),
      ),
    );
  }
}

class AesTest extends StatefulWidget {
  const AesTest({super.key});

  @override
  State<AesTest> createState() => _AesTestState();
}

class _AesTestState extends State<AesTest> {
  String plainText = "";
  String decryptCipherText = "";

  void _testAes() async {
    String currentPath;
    if (Platform.isWindows) {
      currentPath = dirname(Platform.resolvedExecutable);
    } else if (Platform.isAndroid) {
      currentPath = (await getApplicationDocumentsDirectory()).path;
    } else {
      throw "Unsupported Platform";
    }

    const plainText = 'Hello, World from Flutter';
    final testFile = File('$currentPath/test_aes.txt')
      ..createSync()
      ..writeAsStringSync(plainText);

    Concert concert = Concert();
    concert.func.AesEncrypt(
      '$currentPath/test_aes.txt'.toCStr(),
      '$currentPath/test_aes_cipher.txt'.toCStr(),
      '12345678'.toCStr(),
    );
    concert.func.AesDecrypt(
      '$currentPath/test_aes_cipher.txt'.toCStr(),
      '$currentPath/test_aes_decrypt_cipher.txt'.toCStr(),
      '12345678'.toCStr(),
    );

    setState(() {
      this.plainText = plainText;
      this.decryptCipherText =
          File('$currentPath/test_aes_decrypt_cipher.txt').readAsStringSync();
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
          onPressed: _testAes,
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(100, 100)),
          ),
          child: const Icon(Icons.check, size: 50,),
        ),
        Text(
          "Plain:\n$plainText",
          style: const TextStyle(fontSize: 30),
        ),
        Text(
          'Decrypt Cipher Text:\n$decryptCipherText',
          style: const TextStyle(fontSize: 30),
        ),
      ],
    );
  }
}
