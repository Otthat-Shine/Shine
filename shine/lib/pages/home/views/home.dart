// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:shine/common/dialogs.dart';
import 'package:shine/generated/assets.dart';
import 'package:shine/generated/pubspec.dart';
import 'package:shine/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'concert_form.dart';

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shine'),
        actions: const [
          _OtherOptions(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async => await _createConcertFile(context),
              child: const Text('Create Concert File'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => await extractConcertFile(context),
              child: const Text('Extract Concert File'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createConcertFile(BuildContext context) async {
    CreateConcertForm concertForm = CreateConcertForm();
    await concertForm.show(context);

    if (!concertForm.validate()) return;

    EasyLoading.show(status: 'Creating...');

    try {
      await controller.createConcertFile(
        concertForm.files,
        p.join(concertForm.dest, '${concertForm.name}.concert'),
        concertForm.password,
      );

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Create successfully');
    } catch (e) {
      EasyLoading.dismiss();
      Dialogs.error(e.toString());
      return;
    }
  }

  Future<void> extractConcertFile(BuildContext context) async {
    ExtractConcertForm concertForm = ExtractConcertForm();
    await concertForm.show(context);

    if (!concertForm.validate()) return;

    EasyLoading.show(status: 'Extracting...');

    try {
      await controller.extractConcertFile(
        concertForm.concertFile,
        concertForm.dest,
        concertForm.password,
      );

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Extract successfully');
    } catch (e) {
      EasyLoading.dismiss();
      Dialogs.error(e.toString());
      return;
    }

    Get.toNamed(
      AppRoutes.fileManager,
      preventDuplicates: false,
      arguments: {'enableConcert': true, 'path': concertForm.dest},
    );
  }
}

class _OtherOptions extends StatelessWidget {
  const _OtherOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => options(context),
      icon: const Icon(Icons.dehaze),
    );
  }

  List<PopupMenuEntry> options(BuildContext context) {
    return [
      PopupMenuItem(
        child: const Text('About'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const _About();
            },
          );
        },
      ),
    ];
  }
}

class _About extends StatelessWidget {
  const _About({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: 'Shine',
      applicationVersion: 'version: ${Pubspec.version.canonical}',
      applicationIcon: Image.asset(Assets.appIcon, width: 60),
      children: const [
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: '''
「阳光」 之下无君子
「谐乐」 之上无圣贤
在你打开之时，你已然踏上一条不归之路，这里没有互通立交，有的只是通向平行之路的一条匝道。
'''),
              TextSpan(text: '务必三思而后行。', style: TextStyle(color: Colors.red)),
            ],
          ),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
