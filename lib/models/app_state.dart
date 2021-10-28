import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lupiter/lupiter_const.dart';
import 'package:lupiter/utils/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: sort_constructors_first

/// The model that represent the common app state.
///
/// - [locale] stores the current active [Locale].
/// - [theme] stores the current active [ThemeMode].
@immutable
class AppState {
  /// The model that represent the common app state.
  const AppState({
    this.locale = Settings.defaultLocale,
    this.theme = ThemeMode.system,
  });

  /// The locale to use in app.
  final Locale locale;

  /// The theme mode to use in app.
  final ThemeMode theme;

  /// Converting [AppState] to map with string keys.
  Map<String, dynamic> toMap() {
    return {
      'locale': locale.toString(),
      'theme': enumToString(theme),
    };
  }

  /// Converting map with string keys to [AppState].
  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      locale: (map['locale'] as String).toLocale(),
      theme: enumFromString(ThemeMode.values, map['theme']),
    );
  }

  /// Converting [AppState] to encoded object.
  String toJson() => json.encode(toMap());

  /// Converting encoded object to [AppState].
  factory AppState.fromJson(String source) =>
      AppState.fromMap(json.decode(source));

  /// Saving encoded [AppState] on device.
  Future<void> toMemory([SharedPreferences? preferences]) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    await prefs.setString('app_state', toJson());
  }

  /// Getting decoded [AppState] from device.
  ///
  /// If was not previously created, returns the default [AppState] constuctor.
  factory AppState.fromMemory([SharedPreferences? preferences]) {
    final source = preferences?.getString('app_state');
    return source != null ? AppState.fromJson(source) : const AppState();
  }

  /// [AppState] copying.
  AppState copyWith({
    Locale? locale,
    ThemeMode? theme,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppState && other.locale == locale && other.theme == theme;
  }

  @override
  int get hashCode {
    return locale.hashCode ^ theme.hashCode;
  }

  @override
  String toString() => 'AppState(locale: $locale, theme: $theme)';
}
