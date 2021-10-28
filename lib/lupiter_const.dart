import 'package:flutter/material.dart';

/// App Settings
abstract class Settings {
  /// Default localization for this app.
  static const Locale defaultLocale = Locale('en', 'GB');

  /// List of supported localizations for this app.
  static const List<Locale> supportedLocales = <Locale>[
    defaultLocale,
  ];
}
