import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:order_wizard/ui/add_order_screen.dart';
import 'package:order_wizard/ui/edit_order_screen.dart';
import 'package:order_wizard/ui/order_list_screen.dart';

part 'routes.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'navigator');

@TypedGoRoute<OrderListRoute>(
  path: '/',
  routes: [
    TypedGoRoute<EditOrderRoute>(
      path: 'edit-order/:orderId',
    ),
    TypedGoRoute<AddOrderRoute>(
      path: 'add-order',
    ),
  ],
)

@immutable
class OrderListRoute extends GoRouteData {
  const OrderListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OrderListScreen();
  }
}

@immutable
class EditOrderRoute extends GoRouteData {
  final String orderId;
  const EditOrderRoute({required this.orderId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditOrderScreen(orderId: orderId);
  }
}

@immutable
class AddOrderRoute extends GoRouteData {
  const AddOrderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddOrderScreen();
  }
}

