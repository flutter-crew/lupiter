import 'package:flutter/material.dart';
import 'package:lupiter/lupiter_cubit.dart';
import 'package:lupiter/models/app_state.dart';
import 'package:lupiter/models/order_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// ignore_for_file: sort_constructors_first

/// The state for the [LupiterCubit].
@immutable
class LupiterState {
  /// The state for the [LupiterCubit].
  const LupiterState({
    required this.database,
    required this.appState,
    required this.orderState,
  });

  /// The app's database.
  final Database database;

  /// The app state in the app. Contains some verbose variables.
  final AppState appState;

  /// The state of the current orders in the app.
  final OrderState orderState;

  /// Load this state from memory.
  static Future<LupiterState> fromMemory({
    required Database database,
    required SharedPreferences preferences,
  }) async {
    return LupiterState(
      database: database,
      appState: AppState.fromMemory(preferences),
      orderState: await OrderState.fromMemory(database),
    );
  }

  /// Copying.
  LupiterState copyWith({
    AppState? appState,
    OrderState? orderState,
  }) {
    return LupiterState(
      database: database,
      appState: appState ?? this.appState,
      orderState: orderState ?? this.orderState,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LupiterState &&
        other.database == database &&
        other.appState == appState &&
        other.orderState == orderState;
  }

  @override
  int get hashCode =>
      database.hashCode ^ appState.hashCode ^ orderState.hashCode;

  @override
  String toString() {
    return '''LupiterState(database: $database, appState: $appState, orderState: $orderState)''';
  }
}
