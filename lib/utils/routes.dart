import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

@TypedGoRoute<OrderListScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<EditOrderScreenRoute>(
      path: 'edit-order/:orderId',
    ),
    TypedGoRoute<AddOrderScreenRoute>(
      path: 'add-order',
    ),
  ],
)

@immutable
class EditOrderScreenRoute extends GoRouteData {

  final String orderId;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EditOrderScreen(orderId: orderId);
  }
}

@immutable
class OrderListScreenRoute extends GoRouteData {
  const OrderListScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OrderListScreen();
  }
}

@immutable
class AddOrderScreenRoute extends GoRouteData {
  const AddOrderScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AddOrderScreen();
  }
}