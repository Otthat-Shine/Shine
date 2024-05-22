// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/common/paths.dart';
import 'package:shine/routes/app_pages.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Press button to file_manager'),
          onPressed: () async => Get.toNamed(
            AppRoutes.fileManager,
            arguments: {
              'path': await Paths.appRoot,
            },
            preventDuplicates: false,
          ),
        ),
      ),
    );
  }
}
