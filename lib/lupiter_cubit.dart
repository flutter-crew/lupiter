import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lupiter/models/lupiter_state.dart';
import 'package:lupiter/services/app_service.dart';
import 'package:lupiter/services/order_service.dart';

/// The main Cubit.
///
/// All of the functionality is contained inside services
/// of this cubit. The services are initialized when
/// cubit is created in the [_initServices] method.
///
/// The dependencies of the services are updated each time
/// when the state of this cubit changes.
///
/// The cubit should also call the [postInit] function when the
/// context is ready in he app.
class LupiterCubit extends Cubit<LupiterState> {
  /// TruStrain App Cubit
  LupiterCubit(LupiterState state) : super(state) {
    _initServices();
    _updateDependencies(state);
    stream.listen(_updateDependencies);
  }

  /// The variable that shows if [postInit] was called.
  bool _hadPostInited = false;

  /// Service that operates the state of the app.
  late final AppService appService;

  /// Services that changes the state of current orders.
  late final OrderService orderService;

  /// The method that initializes this cubit's services.
  void _initServices() {
    appService = AppService(
      changeAppStateCallback: (appState) => emit(
        // also save to device
        state.copyWith(appState: appState..toMemory()),
      ),
    );

    orderService = OrderService(
      changeOrderStateCallback: (orderState) => emit(
        state.copyWith(orderState: orderState),
      ),
    );
  }

  /// The function for updating dependencies of this cubit.
  Future<void> _updateDependencies(LupiterState state) async {
    orderService
      ..database = state.database
      ..currrentOrderState = state.orderState;

    appService.currrentAppState = state.appState;
  }

  /// The additional initialisation with context.
  Future<void> postInit(BuildContext context) async {
    if (_hadPostInited) {
      return;
    } else {
      _hadPostInited = !_hadPostInited;
    }

    appService.changeAppTheme(state.appState.theme);
  }
}
