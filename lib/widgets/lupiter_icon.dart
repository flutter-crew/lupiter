import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: sort_constructors_first

/// The icon extension with a [width], [height],
/// [color], [alignment] and [padding].
class PositionIconData extends IconData {
  /// Creates icon data with [width], [height],
  /// [color], [alignment] and [padding].
  const PositionIconData(
    int codePoint, {
    String? fontFamily,
    String? fontPackage,
    bool matchTextDirection = false,
    double? width,
    double? height,
    Color? color,
    AlignmentGeometry? alignment,
    BoxFit? fit,
    AlignmentGeometry? selfAlignment,
    EdgeInsetsGeometry? padding,
  })  : width = width ?? 24,
        height = height ?? 24,
        color = color ?? Colors.black,
        alignment = alignment ?? Alignment.center,
        fit = fit ?? BoxFit.contain,
        selfAlignment = selfAlignment ?? Alignment.center,
        padding = padding ?? EdgeInsets.zero,
        super(
          codePoint,
          fontFamily: fontFamily,
          fontPackage: fontPackage,
          matchTextDirection: matchTextDirection,
        );

  /// The width of this icon when positioned.
  final double width;

  /// The height of this icon when positioned.
  final double height;

  /// The color of this icon when positioned.
  final Color color;

  /// The alignment of this icon when positioned.
  final AlignmentGeometry alignment;

  /// The fit of the icon when positioned within its bounds.
  final BoxFit fit;

  /// The alignment of this icon when positioned within its bounds.
  final AlignmentGeometry selfAlignment;

  /// The padding of this icon when positioned.
  final EdgeInsetsGeometry padding;

  /// Constructor of a [PositionIconData] from [IconData].
  factory PositionIconData.fromIconData(
    IconData icon, {
    double? width,
    double? height,
    Color? color,
    AlignmentGeometry? alignment,
    BoxFit? fit,
    AlignmentGeometry? selfAlignment,
    EdgeInsetsGeometry? padding,
  }) {
    return PositionIconData(
      icon.codePoint,
      width: width,
      height: height,
      color: color,
      alignment: alignment,
      fit: fit,
      selfAlignment: selfAlignment,
      padding: padding,
      fontFamily: icon.fontFamily,
      fontPackage: icon.fontPackage,
      matchTextDirection: icon.matchTextDirection,
    );
  }
}

/// The widget to stack icons on top of each other.
class TruStrainMultiIcon extends StatelessWidget {
  /// The widget to stack icons on top of each other.
  TruStrainMultiIcon(
    this.icons, {
    this.width,
    this.height,
    Key? key,
  })  : assert(
          _areAllItemsInside(icons, width, height),
          'One or more of the icons are bigger than maximum size',
        ),
        super(key: key);

  /// The list of icons to display.
  final List<PositionIconData> icons;

  /// The width of the final widget.
  final double? width;

  /// The height of the final widget.
  final double? height;

  static bool _areAllItemsInside(
    List<PositionIconData> icons,
    double? width,
    double? height,
  ) {
    final Size size;
    if (height != null && width != null) {
      size = Size(width, height);
    } else if (width == null && height != null) {
      size = Size.fromHeight(height);
    } else if (height == null && width != null) {
      size = Size.fromWidth(width);
    } else {
      return true;
    }

    for (final icon in icons) {
      final iconWidth = icon.width + icon.padding.horizontal;
      final iconHeight = icon.height + icon.padding.vertical;

      final iconSize = Offset(iconWidth, iconHeight);
      if (!size.contains(iconSize)) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          for (final icon in icons)
            Align(
              alignment: icon.alignment,
              child: Padding(
                padding: icon.padding,
                child: LupiterIcon(
                  icon,
                  width: icon.width,
                  color: icon.color,
                  fit: icon.fit,
                  alignment: icon.selfAlignment,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<PositionIconData>('icons', icons))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height));
  }
}

/// The widget to display icon properly from [IconData].
class LupiterIcon extends StatelessWidget {
  /// The widget to display icon properly from [IconData].
  const LupiterIcon(
    this.icon, {
    this.width = 20,
    this.height = 20,
    this.color,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Key? key,
  })  : fit = fit ?? BoxFit.scaleDown,
        alignment = alignment ?? Alignment.center,
        super(key: key);

  /// The icon to display.
  final IconData icon;

  /// The size of the icon.
  final double? width;

  /// The size of the icon.
  final double? height;

  /// The color of this icon.
  final Color? color;

  /// The fit of this icon.
  final BoxFit fit;

  /// The alignment of this icon within its bounds.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          inherit: false,
          letterSpacing: 0,
          fontSize: height,
          color: color ?? Theme.of(context).iconTheme.color,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      )
      ..layout();

    return SizedBox(
      width: width ?? painter.width,
      height: height,
      child: FittedBox(
        fit: fit,
        alignment: alignment,
        child: Text.rich(painter.text!),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(DoubleProperty('height', height))
      ..add(DoubleProperty('width', width))
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<BoxFit>('fit', fit))
      ..add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
  }
}
