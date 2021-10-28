import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// screen width factor to use in horizontal padding
const double defaultPaddingScreenWidthFactor = 0.07;

/// screen height factor to use in vertical padding
const double defaultPaddingScreenHeightFactor = 0.035;

/// default screen padding of the scaffold content
EdgeInsets screenPadding(BuildContext context, {bool withInsets = true}) =>
    horizontalPadding(context) +
    verticalPadding(context, withInsets: withInsets);

/// default horizontal padding
EdgeInsets horizontalPadding(BuildContext context) {
  return EdgeInsets.symmetric(
    horizontal:
        MediaQuery.of(context).size.width * defaultPaddingScreenWidthFactor,
  );
}

/// default vertical padding (can also be [withInsets])
EdgeInsets verticalPadding(BuildContext context, {bool withInsets = false}) {
  var insets = EdgeInsets.symmetric(
    vertical:
        MediaQuery.of(context).size.height * defaultPaddingScreenHeightFactor,
  );
  if (withInsets) {
    insets += EdgeInsets.only(
      top: MediaQuery.of(context).viewInsets.top,
      bottom: MediaQuery.of(context).viewInsets.bottom,
    );
  }
  return insets;
}

/// [SystemUiOverlay] to set at start
SystemUiOverlayStyle defaultSystemUiOverlay(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  final inverseBrightness =
      brightness == Brightness.light ? Brightness.dark : Brightness.light;

  return SystemUiOverlayStyle(
    systemNavigationBarColor: Theme.of(context).colorScheme.surface,
    systemNavigationBarDividerColor: Theme.of(context).colorScheme.surface,
    systemNavigationBarIconBrightness: inverseBrightness,
    statusBarColor: Theme.of(context).colorScheme.onSurface.withOpacity(1 / 5),
    statusBarBrightness: Theme.of(context).brightness,
    statusBarIconBrightness: inverseBrightness,
  );
}

/// TruStrain text themes
TextTheme get customTextTheme {
  return GoogleFonts.montserratTextTheme(
    const TextTheme(
      headline1: TextStyle(fontSize: 48),
      headline2: TextStyle(fontSize: 32),
      headline3: TextStyle(fontSize: 24),
      headline4: TextStyle(fontSize: 16),
      headline5: TextStyle(fontSize: 14),
      headline6: TextStyle(fontSize: 12),
      subtitle1: TextStyle(fontSize: 20),
      subtitle2: TextStyle(fontSize: 18),
      bodyText1: TextStyle(fontSize: 14),
      bodyText2: TextStyle(fontSize: 12),
      caption: TextStyle(fontSize: 14),
      button: TextStyle(fontSize: 16),
    ),
  );
}

/// [lightTheme] to be used in the app
ThemeData get lightTheme {
  return ThemeData.from(
    colorScheme: const ColorScheme.light(
      error: Colors.red,
      primary: Color(0xFFF9911E),
      primaryVariant: Color(0xFFF9700B),
      secondary: Color(0xFFE0AA86),
      secondaryVariant: Color(0xFFE0AA86),
      surface: Color(0xFFF9DAC5),
    ),
    textTheme: customTextTheme,
  ).copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    hintColor: const Color(0xFF333333).withOpacity(3 / 4),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0678BF),
      shadowColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );
}

/// [darkTheme] to be used in the app
ThemeData get darkTheme {
  return ThemeData.from(
    colorScheme: const ColorScheme.dark(
      error: Colors.red,
      primary: Color(0xFFF9911E),
      primaryVariant: Color(0xFFF9700B),
      secondary: Color(0xFFE0AA86),
      secondaryVariant: Color(0xFFE0AA86),
      surface: Color(0xFF404040),
    ),
    textTheme: customTextTheme,
  ).copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    hintColor: const Color(0xFF333333).withOpacity(3 / 4),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0678BF),
      shadowColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );
}

/// The functions for retrieving correct colors from theme
extension ThemeDataUtils on ThemeData {
  /// gets theme background color depending on theme brightness
  Color get surfaceColor {
    return brightness == Brightness.light
        ? colorScheme.primary
        : colorScheme.surface;
  }

  /// gets theme on surface color depending on theme brightness
  Color get onSurfaceColor {
    if (brightness == Brightness.light) {
      return Colors.grey.shade200;
    } else {
      return Color.lerp(
        Colors.grey.shade200,
        scaffoldBackgroundColor,
        99 / 100,
      )!;
    }
  }
}
