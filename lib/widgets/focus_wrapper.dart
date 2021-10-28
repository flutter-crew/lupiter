import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Unfocus scope primary focus node on action
class FocusWrapper extends StatelessWidget {
  /// Unfocus scope primary focus node on action
  const FocusWrapper({
    required this.child,
    this.unfocus = true,
    this.unfocussableKeys = const [],
    Key? key,
  }) : super(key: key);

  /// is this unfocusing on tap
  final bool unfocus;

  /// keys of the widgets that should not trigger unfocus (e.g. fields itself)
  final List<GlobalKey<dynamic>> unfocussableKeys;

  /// child of the widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: unfocus ? (event) => _unfocus(context, event) : null,
      child: child,
    );
  }

  /// unfocus the current widget scope
  void _unfocus(BuildContext context, PointerDownEvent event) {
    for (final key in unfocussableKeys) {
      if (key.globalPaintBounds?.contains(event.position) ?? false) {
        return;
      }
    }

    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('unfocus', unfocus))
      ..add(
        IterableProperty<GlobalKey<dynamic>>(
          'unfocussableKeys',
          unfocussableKeys,
        ),
      );
  }
}

/// get the current widget position on screen
extension _GlobalKeyPaintExtension on GlobalKey<dynamic> {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();

    if (translation != null && renderObject != null) {
      return renderObject.paintBounds
          .shift(Offset(translation.x, translation.y));
    }
  }
}
