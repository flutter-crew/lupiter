import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lupiter/generated/lupiter_icons.g.dart';
import 'package:lupiter/generated/lupiter_localization.g.dart';
import 'package:lupiter/utils/enum_to_string.dart';
import 'package:lupiter/widgets/input_form.dart';
import 'package:lupiter/widgets/lupiter_icon.dart';
import 'package:lupiter/widgets/orders_review.dart';

/// bottom navigation bar screens
enum NavigationScreenType {
  /// The [InputForm] screen.
  inputForm,

  /// The screen for reviewng inputs.
  review,
}

/// navigation bar asset path, labels
extension NavigationScreenExtension on NavigationScreenType {
  /// gets the navigation icon
  IconData get icon {
    switch (this) {
      case NavigationScreenType.inputForm:
        return LupiterIcons.write;
      case NavigationScreenType.review:
        return LupiterIcons.info;
    }
  }

  /// get the navigation bar item translation
  String get translation => '${TR.navigation}.${enumToString(this)}'.tr();
}

/// The restoration value for [NavigationScreenType].
///
/// Default value is [NavigationScreenType.inputForm].
class RestorableNavigationScreenType
    extends RestorableValue<NavigationScreenType> {
  @override
  NavigationScreenType createDefaultValue() => NavigationScreenType.inputForm;

  @override
  Object? toPrimitives() => value.index;

  @override
  NavigationScreenType fromPrimitives(Object? data) {
    return data is int
        ? NavigationScreenType.values.elementAt(data)
        : createDefaultValue();
  }

  @override
  void didUpdateValue(NavigationScreenType? oldValue) {
    if (oldValue != value) {
      notifyListeners();
    }
  }
}

/// App screen foreground to switch on tabs.
class NavigationScreen extends StatefulWidget {
  /// App screen foreground to switch on tabs.
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  NavigationScreenState createState() => NavigationScreenState();
}

/// App screen foreground to switch on tabs.
class NavigationScreenState extends State<NavigationScreen>
    with RestorationMixin, TickerProviderStateMixin {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final TabController _tabController;
  late final AnimationController _tabAnimationController;
  late final RestorableInt _currentScreen;

  static const double _navBarHeight = 45;

  @override
  void initState() {
    _scaffoldKey =
        GlobalKey<ScaffoldState>(debugLabel: '${restorationId}_scaffold');

    _currentScreen = RestorableInt(0);

    _tabController = TabController(
      vsync: this,
      length: NavigationScreenType.values.length,
    )..addListener(() async {
        setState(() => _currentScreen.value = _tabController.index);
      });

    _tabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 400),
      value: 1,
    );

    super.initState();
  }

  @override
  void dispose() {
    _currentScreen.dispose();
    _tabController.dispose();
    _tabAnimationController.dispose();
    super.dispose();
  }

  @override
  String get restorationId => 'nav';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentScreen, '${restorationId}_current_screen');

    if (initialRestore) {
      _tabController.index = _currentScreen.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          InputForm(),
          OrdersReview(),
        ],
      ),
      bottomNavigationBar: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline5!,
        child: ConvexAppBar(
          // Key is needed for proper animating
          key: Key('${restorationId}_bar${_tabController.index}'),
          controller: _tabController,
          disableDefaultTabController: true,
          style: TabStyle.textIn,
          top: -24,
          height: _navBarHeight,
          curve: Curves.easeInQuad,
          backgroundColor: Theme.of(context).colorScheme.primary,
          activeColor: Colors.white,
          color: Colors.white,
          items: List<TabItem>.generate(
            NavigationScreenType.values.length,
            (index) => _bottomNavigationBarItem(context, index),
          ),
        ),
      ),
    );
  }

  NavigationScreenType _currentScreenType([int? index]) {
    return NavigationScreenType.values.elementAt(index ?? _tabController.index);
  }

  TabItem _bottomNavigationBarItem(BuildContext context, int index) {
    final screen = _currentScreenType(index);
    return TabItem(
      icon: LupiterIcon(screen.icon, color: Colors.white, height: 24),
      activeIcon: Padding(
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
        child: LupiterIcon(screen.icon, color: Colors.white, height: 24),
      ),
      title: screen.translation,
    );
  }
}
