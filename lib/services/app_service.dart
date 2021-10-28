import 'package:flutter/material.dart';
import 'package:lupiter/lupiter_const.dart';
import 'package:lupiter/models/app_state.dart';

/// The callback with app state.
typedef ChangeAppState = void Function(AppState appState);

/// The service for managing the [AppState].
class AppService {
  /// The service for managing the [AppState].
  AppService({
    required this.changeAppStateCallback,
  });

  /// The current [AppState] in the cubit.
  late AppState currrentAppState;

  /// Callback for changing app state.
  final ChangeAppState changeAppStateCallback;

  /// Changes the active app theme.
  ///
  /// Changes theme to [ThemeMode.light] if it was
  /// [ThemeMode.dark] and vice versa.
  void changeAppTheme(ThemeMode theme) {
    return changeAppStateCallback(
      currrentAppState.copyWith(theme: theme),
    );
  }

  /// Changes the active app locale.
  ///
  /// Changes theme to [ThemeMode.light] if it was
  /// [ThemeMode.dark] and vice versa.
  ///
  /// The initial value is the device predefined
  /// theme setting.
  void changeAppLocale(Locale locale) {
    if (Settings.supportedLocales.contains(locale)) {
      return changeAppStateCallback(
        currrentAppState.copyWith(locale: locale),
      );
    }
  }
}
