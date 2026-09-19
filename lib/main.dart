// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/core/_core.dart';

// TODO BBCode

Future<void> main() async {
  // * Ensuring widgets binding at startup.
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // * Summoning splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // * Creating app startup instance for further initialization.
  const appStartup = AppStartup();
  final container = await appStartup.initializeProviderContainer();
  final root = await appStartup.createRootWidget(container: container);

  // * Entry point
  runApp(root);

  // The startup error widget can be the first rendered frame. Remove the
  // preserved native splash here as well, so a failed first build never looks
  // like the application has frozen on its logo.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}
