// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:shine/common/general_dialog.dart';
import 'package:shine/routes/app_pages.dart';

void main(List<String> args) {
  init();

  runZonedGuarded(() {
    runApp(GetMaterialApp(
      initialRoute: AppPages.initial,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'HarmonyOS Sans',
        useMaterial3: true,
      ),
    ));
  }, (e, s) {
    GeneralDialog.errorDialog(e.toString());
  });
}

void init() {
  // Flutter Easy Loading
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
