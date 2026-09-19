import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vndb_lite/src/app.dart';
import 'package:vndb_lite/src/util/responsive.dart';
import 'package:vndb_lite/src/util/context_shortcut.dart';
import 'package:vndb_lite/src/routing/app_router.dart';
import 'package:vndb_lite/src/constants/local_db_constants.dart';
import 'package:vndb_lite/src/core/local_db/shared_prefs.dart';
import 'package:vndb_lite/src/features/vn/domain/p1.dart';
import 'package:vndb_lite/src/util/alt_provider_reader.dart';

class VnDetailAppBar extends StatelessWidget {
  const VnDetailAppBar({super.key, required this.p1});

  final VnDataPhase01 p1;

  Future<void> _chooseCover() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );
    if (image == null) return;
    final directory = await getApplicationDocumentsDirectory();
    final extension = image.path.split('.').last;
    final destination = File(
      '${directory.path}/vnpockets_cover_${p1.id}.$extension',
    );
    await File(image.path).copy(destination.path);
    await ref_
        .read(sharedPrefProvider)
        .setString('${DBKeys.CUSTOM_COVER_PATH}${p1.id}', destination.path);
  }

  Future<void> _clearCover() => ref_
      .read(sharedPrefProvider)
      .remove('${DBKeys.CUSTOM_COVER_PATH}${p1.id}');

  @override
  Widget build(BuildContext context) {
    final vnUrl = Uri.parse('https://vndb.org/${p1.id}');

    return SliverAppBar(
      snap: true,
      floating: true,
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      toolbarHeight: responsiveUI.own(0.22),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: kColor(context).tertiary,
        shadows: const [Shadow(color: Colors.black)],
      ),
      actions: [
        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        // Back button
        Container(
          margin: EdgeInsets.only(left: responsiveUI.own(0.045)),
          child: Tooltip(
            message: 'Back',
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              // IconButton doesn't support longPress, so GestureDetector is used to provide the callback.
              onLongPress: () {
                final fullRoute = App.currentFullRoute;

                if (fullRoute.contains(AppRoute.search.name)) {
                  context.goNamed(AppRoute.search.name);
                  //
                } else if (fullRoute.contains(AppRoute.collection.name)) {
                  context.goNamed(AppRoute.collection.name);
                  //
                } else if (fullRoute.contains(AppRoute.home.name)) {
                  context.goNamed(AppRoute.home.name);
                  //
                } else {
                  context.goNamed(AppRoute.home.name);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kColor(context).primary.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: IconButton(
                  padding: EdgeInsets.all(responsiveUI.own(0.034)),
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: responsiveUI.standardIcon,
                    color: kColor(context).tertiary,
                  ),
                ),
              ),
            ),
          ),
        ),
        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //
        const Spacer(),
        PopupMenuButton<String>(
          tooltip: 'Copy & cover options',
          icon: Icon(Icons.more_vert, color: kColor(context).tertiary),
          onSelected: (value) async {
            switch (value) {
              case 'copyTitle':
                await Clipboard.setData(ClipboardData(text: p1.displayTitle));
              case 'copyDescription':
                await Clipboard.setData(
                  ClipboardData(text: p1.description ?? ''),
                );
              case 'chooseCover':
                await _chooseCover();
              case 'clearCover':
                await _clearCover();
            }
          },
          itemBuilder:
              (_) => const [
                PopupMenuItem(value: 'copyTitle', child: Text('Copy title')),
                PopupMenuItem(
                  value: 'copyDescription',
                  child: Text('Copy description'),
                ),
                PopupMenuItem(
                  value: 'chooseCover',
                  child: Text('Choose custom cover image'),
                ),
                PopupMenuItem(
                  value: 'clearCover',
                  child: Text('Remove custom cover image'),
                ),
              ],
        ),
        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        // Share button
        Container(
          margin: EdgeInsets.symmetric(horizontal: responsiveUI.own(0.035)),
          decoration: BoxDecoration(
            color: kColor(context).primary.withOpacity(0.75),
            borderRadius: BorderRadius.circular(60),
          ),
          child: IconButton(
            tooltip: 'Share',
            padding: EdgeInsets.all(responsiveUI.own(0.034)),
            onPressed: () => Share.share('$vnUrl'),
            icon: Icon(
              Icons.share,
              size: responsiveUI.standardIcon,
              color: kColor(context).tertiary,
            ),
          ),
        ),
        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        // Go to site button
        Container(
          margin: EdgeInsets.only(right: responsiveUI.own(0.035)),
          decoration: BoxDecoration(
            color: kColor(context).primary.withOpacity(0.75),
            borderRadius: BorderRadius.circular(60),
          ),
          child: IconButton(
            tooltip: 'Go to site',
            padding: EdgeInsets.all(responsiveUI.own(0.034)),
            onPressed: () => launchUrl(vnUrl),
            icon: Icon(
              Icons.travel_explore,
              size: responsiveUI.standardIcon,
              color: kColor(context).tertiary,
            ),
          ),
        ),
        //
        // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        //
      ],
    );
  }
}
