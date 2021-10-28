import 'package:flutter/material.dart';
import 'package:lupiter/models/order_model.dart';
import 'package:sqflite/sqflite.dart';

// ignore_for_file: sort_constructors_first

/// The model that represent the orders state.
@immutable
class OrderState {
  /// The model that represent Database the common app state.
  const OrderState({this.orders = const <OrderModel>[]});

  /// The locale to use in app.
  final Iterable<OrderModel> orders;

  /// Getting [OrderState] from database.
  ///
  /// If was not previously created, returns the default [OrderState]
  /// constuctor.
  static Future<OrderState> fromMemory(Database database) async {
    return OrderState(
      orders: (await database.query('orders')).map(
        (order) => OrderModel.fromMap(order),
      ),
    );
  }

  /// [OrderState] copying.
  OrderState copyWith({
    Iterable<OrderModel>? orders,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is OrderState && other.orders == orders;
  }

  @override
  int get hashCode => orders.hashCode;

  @override
  String toString() => 'OrderState(orders: $orders)';
}
