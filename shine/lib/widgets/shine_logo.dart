// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:shine/generated/assets.dart';

class ShineLogo extends StatelessWidget {
  const ShineLogo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double? iconSize = size ?? iconTheme.size;

    return Image.asset(
      Assets.appIcon,
      width: iconSize,
      height: iconSize,
    );
  }
}
