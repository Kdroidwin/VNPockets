// coverage:ignore-file

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../constants/_constants.dart';
import '../../core/_core.dart';
import 'data/theme_data.dart';

part 'theme_data_provider.g.dart';

/// Persisted visual preferences that need to update the UI immediately.
final customBackgroundPathProvider =
    NotifierProvider<CustomBackgroundPath, String?>(
      CustomBackgroundPath.new,
      dependencies: [sharedPrefProvider],
    );

class CustomBackgroundPath extends Notifier<String?> {
  @override
  String? build() =>
      ref.read(sharedPrefProvider).getString(DBKeys.CUSTOM_BACKGROUND_PATH);

  void update(String? path) => state = path;
}

final japaneseTitlesProvider = NotifierProvider<JapaneseTitles, bool>(
  JapaneseTitles.new,
  dependencies: [sharedPrefProvider],
);

class JapaneseTitles extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(sharedPrefProvider).getBool(DBKeys.JAPANESE_TITLES_CONF) ??
      false;

  void update(bool enabled) => state = enabled;
}

final japaneseUiProvider = NotifierProvider<JapaneseUi, bool>(
  JapaneseUi.new,
  dependencies: [sharedPrefProvider],
);

class JapaneseUi extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(sharedPrefProvider).getBool(DBKeys.JAPANESE_UI_CONF) ?? false;

  void update(bool enabled) => state = enabled;
}

/// Hexadecimal accent color used by the AMOLED Black theme.
final amoledAccentHexProvider = NotifierProvider<AmoledAccentHex, String>(
  AmoledAccentHex.new,
  dependencies: [sharedPrefProvider],
);

class AmoledAccentHex extends Notifier<String> {
  @override
  String build() =>
      ref.read(sharedPrefProvider).getString(DBKeys.AMOLED_ACCENT_COLOR) ??
      '#BB86FC';

  void update(String hex) => state = hex;
}

@Riverpod(dependencies: [sharedPref])
class AppThemeState extends _$AppThemeState {
  @override
  ThemeCode build() => _appTheme;

  ThemeCode get _appTheme {
    try {
      final sharedPref = ref.read(sharedPrefProvider);
      final String? theme = sharedPref.getString(DBKeys.THEME_CONF);

      // Validate
      if (theme != null) return ThemeCode.values.byName(theme);
    } catch (e) {
      // Doesn't care if there's an error, just return default conf.
    }

    return Default.THEME_CONF;
  }

  set appTheme(ThemeCode themeCode) {
    final sharedPref = ref.read(sharedPrefProvider);
    sharedPref.setString(DBKeys.THEME_CONF, themeCode.name);
    sharedPref.reload();

    state = themeCode;
  }
}
