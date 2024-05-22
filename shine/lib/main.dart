// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:shine/routes/app_pages.dart';

void main(List<String> args) {
  runApp(GetMaterialApp(
    initialRoute: AppPages.initial,
    debugShowCheckedModeBanner: false,
    getPages: AppPages.routes,
  ));
}
