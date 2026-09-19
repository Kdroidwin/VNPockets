import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vndb_lite/src/features/theme/theme_data_provider.dart';
import 'package:vndb_lite/src/util/context_shortcut.dart';

class GenericBackground extends ConsumerWidget {
  const GenericBackground({
    super.key,
    this.imagePath,
    this.useGradientOverlay = false,
    this.imageWidget,
  });

  final String? imagePath;
  final bool useGradientOverlay;
  final Widget? imageWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = kScreenWidth(context);
    final height = kScreenHeight(context);
    final customBackgroundPath = ref.watch(customBackgroundPathProvider);
    final effectiveImagePath =
        customBackgroundPath ?? (imagePath?.isEmpty == true ? null : imagePath);

    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: kColor(context).primary.withAlpha(150),
            ),
          ),
        ),
        if (effectiveImagePath == null && imageWidget != null) imageWidget!,
        if (effectiveImagePath != null && imageWidget == null)
          effectiveImagePath.startsWith('/')
              ? Image.file(
                File(effectiveImagePath),
                opacity: const AlwaysStoppedAnimation(0.6),
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
              : Image.asset(
                effectiveImagePath,
                opacity: const AlwaysStoppedAnimation(0.6),
                height: height,
                width: width,
                fit: BoxFit.cover,
              ),
        if (useGradientOverlay)
          SizedBox(
            width: width,
            height: height,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(70, 240, 230, 230),
                    Color.fromARGB(150, 40, 40, 40),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
