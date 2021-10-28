import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget that shows splash on stream event.
class LupiterData extends StatefulWidget {
  /// Widget that shows splash on stream event.
  const LupiterData({
    required this.child,
    required this.splash,
    this.duration = const Duration(seconds: 1),
    Key? key,
  }) : super(key: key);

  /// The child in the tree.
  final Widget child;

  /// The splash widget to be shown.
  final Widget splash;

  /// The duration of the fade animation.
  final Duration duration;

  /// The inherited widget data for this widget.
  static LupiterDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LupiterDataWidget>()!;
  }

  /// The inherited widget data for this widget.
  static LupiterDataWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LupiterDataWidget>();
  }

  @override
  LupiterDataState createState() => LupiterDataState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Widget>('splash', splash))
      ..add(DiagnosticsProperty<Widget>('child', child))
      ..add(DiagnosticsProperty<Duration>('showDuration', duration));
  }
}

/// Widget that shows splash on stream event.
class LupiterDataState extends State<LupiterData> {
  late StreamController<bool> _controller;

  @override
  void initState() {
    _controller = StreamController<bool>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_controller.hasListener) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        setState(() => _controller = StreamController<bool>());
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = WidgetsBinding.instance!.window.physicalSize.height;
    final width = WidgetsBinding.instance!.window.physicalSize.width;
    return LupiterDataWidget(
      _controller,
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _controller.stream,
        builder: (context, snapshot) {
          return Directionality(
            textDirection: ui.TextDirection.ltr,
            child: AnimatedCrossFade(
              firstChild: LimitedBox(
                maxHeight: height,
                maxWidth: width,
                child: widget.child,
              ),
              secondChild: LimitedBox(
                maxHeight: height,
                maxWidth: width,
                child: widget.splash,
              ),
              crossFadeState: snapshot.data ?? false
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: widget.duration,
              firstCurve: const Interval(1 / 2, 1, curve: Curves.easeInQuad),
              secondCurve: const Interval(1 / 2, 1, curve: Curves.easeOutQuad),
            ),
          );
        },
      ),
    );
  }
}

/// The content for the [LupiterData].
class LupiterDataWidget extends InheritedWidget {
  /// The content for the [LupiterData].
  const LupiterDataWidget(
    this._splashController, {
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  /// The splash controller for toggling splash widget.
  final StreamController<bool> _splashController;

  /// The function for controlling visibilty of splash widget.
  void Function(bool) get setSplash => _splashController.add;

  @override
  bool updateShouldNotify(LupiterDataWidget oldWidget) {
    return oldWidget._splashController != _splashController;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<void Function(bool p1)>('setSplash', setSplash),
    );
  }
}
