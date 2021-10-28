import 'package:lupiter/models/app_state.dart';
import 'package:lupiter/models/order_model.dart';
import 'package:lupiter/models/order_state.dart';
import 'package:sqflite/sqflite.dart';

/// The callback with app state.
typedef ChangeOrderState = void Function(OrderState orderState);

/// The service for managing the [AppState].
class OrderService {
  /// The service for managing the [AppState].
  OrderService({required this.changeOrderStateCallback});

  /// The current [AppState] in the cubit.
  late OrderState currrentOrderState;

  /// The current app's database.
  late Database database;

  /// Callback for changing order state.
  final ChangeOrderState changeOrderStateCallback;

  /// Adds the [order] to the app.
  Future<void> addOrder(OrderModel order) async {
    await database.transaction((database) async {
      await database.insert(
        'orders',
        order.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    return changeOrderStateCallback(await OrderState.fromMemory(database));
  }

  /// Removes the [order] from the app.
  Future<void> removeOrder(OrderModel order) async {
    await database.transaction((database) async {
      await database.delete('orders', where: 'id = ?', whereArgs: [order.id]);
    });
    return changeOrderStateCallback(await OrderState.fromMemory(database));
  }
}
