import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lupiter/generated/lupiter_icons.g.dart';

/// The default icon button.
///
/// Also used as an appbar action button.
class LupiterIconButton extends StatelessWidget {
  /// The default icon button.
  ///
  /// Also used as an appbar action button.
  const LupiterIconButton({
    required this.icon,
    this.color = Colors.white,
    this.tooltip,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  /// The icon for this button.
  final Widget icon;

  /// The color of this icon.
  final Color? color;

  /// The tooltip for this button.
  final String? tooltip;

  /// The function for this button.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 20,
        color: color,
        icon: icon,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Widget>('icon', icon))
      ..add(ColorProperty('color', color))
      ..add(StringProperty('tooltip', tooltip))
      ..add(DiagnosticsProperty<void Function()>('onPressed', onPressed));
  }
}

/// The icon button to go back to previous screen.
class LupiterBackButton extends StatelessWidget {
  /// The icon button to go back to previous screen.
  const LupiterBackButton({
    this.icon = const Icon(LupiterIcons.back),
    this.color = Colors.white,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  /// The icon of this button.
  final Widget icon;

  /// The color of this icon.
  final Color color;

  /// The functionality of this button.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return LupiterIconButton(
      icon: icon,
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onPressed ?? Navigator.of(context).maybePop,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Widget?>('icon', icon))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<void Function()>('onPressed', onPressed));
  }
}
