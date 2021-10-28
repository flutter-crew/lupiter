import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lupiter/generated/lupiter_icons.g.dart';
import 'package:lupiter/generated/lupiter_localization.g.dart';
import 'package:lupiter/lupiter_cubit.dart';
import 'package:lupiter/lupiter_style.dart';
import 'package:lupiter/models/lupiter_state.dart';
import 'package:lupiter/models/order_model.dart';
import 'package:lupiter/widgets/lupiter_icon.dart';

/// The screen to review current orders.
class OrdersReview extends StatefulWidget {
  /// The screen to review current orders.
  const OrdersReview({Key? key}) : super(key: key);

  @override
  OrdersReviewState createState() => OrdersReviewState();
}

/// The screen to review current orders.
class OrdersReviewState extends State<OrdersReview>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late List<OrderModel> _orders;

  @override
  void initState() {
    _orders = context.read<LupiterCubit>().state.orderState.orders.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<LupiterCubit, LupiterState>(
      listenWhen: (previous, current) =>
          previous.orderState != current.orderState,
      listener: (context, state) {
        setState(() => _orders = state.orderState.orders.toList());
      },
      child: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverPadding(
            padding: horizontalPadding(context) +
                const EdgeInsets.only(top: 100, bottom: 25),
            sliver: SliverToBoxAdapter(
              child: Text(
                TR.reviewOrders.tr(),
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final order = _orders.elementAt(index);
                return Dismissible(
                  key: ValueKey(order),
                  direction: DismissDirection.endToStart,
                  dismissThresholds: const <DismissDirection, double>{
                    DismissDirection.endToStart: 1 / 4,
                  },
                  onDismissed: (direction) async {
                    setState(() => _orders.remove(order));
                    final orderService =
                        context.read<LupiterCubit>().orderService;
                    await orderService.removeOrder(order);
                  },
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        order.id.toString(),
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    dense: true,
                    contentPadding: horizontalPadding(context),
                    horizontalTitleGap: 0,
                    tileColor: index.isOdd ? Theme.of(context).cardColor : null,
                    title: Text(
                      order.name,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    subtitle: Text(
                      <String>[
                        if (order.address.isNotEmpty) order.address,
                        if (order.zipCode.isNotEmpty) order.zipCode.toString(),
                        if (order.city.isNotEmpty) order.city,
                      ].join(', '),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    trailing: LupiterIcon(
                      LupiterIcons.drag,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
              childCount: _orders.length,
            ),
          ),
        ],
      ),
    );
  }
}
