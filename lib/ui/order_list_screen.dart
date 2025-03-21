import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_wizard/controller/order_controller.dart';
import 'package:order_wizard/models/order.dart';
import 'package:order_wizard/utils/service_locator.dart';
import 'package:go_router/go_router.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = getIt<OrderController>();

    // Load orders when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.getOrders();
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Orders'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () => context.go('/add-order'),
        ),
      ),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: orderController,
          builder: (context, _) {
            final orders = orderController.orders;
            
            if (orders.isEmpty) {
              return const Center(
                child: Text('No orders yet. Add one by tapping the + button.'),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Order Number')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Note')),
                    DataColumn(label: Text('Has Picture')),
                    DataColumn(label: Text('Commented')),
                    DataColumn(label: Text('Revealed')),
                    DataColumn(label: Text('Reimbursed')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: orders.map((order) => _buildOrderRow(context, order)).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  DataRow _buildOrderRow(BuildContext context, Order order) {
    return DataRow(
      cells: [
        DataCell(Text(order.orderNumber)),
        DataCell(Text('\$${order.amount.toStringAsFixed(2)}')),
        DataCell(Text(order.note ?? '-')),
        DataCell(Icon(
          order.commentWithPicture ? CupertinoIcons.photo : CupertinoIcons.photo_fill_on_rectangle_fill,
          color: order.commentWithPicture ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
        )),
        DataCell(Icon(
          order.commented ? CupertinoIcons.chat_bubble_fill : CupertinoIcons.chat_bubble,
          color: order.commented ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
        )),
        DataCell(Icon(
          order.revealed ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash,
          color: order.revealed ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
        )),
        DataCell(Icon(
          order.reimbursed ? CupertinoIcons.money_dollar_circle_fill : CupertinoIcons.money_dollar_circle,
          color: order.reimbursed ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
        )),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.pencil),
              onPressed: () => context.go('/edit-order/${order.orderNumber}'),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Delete Order'),
                    content: Text('Are you sure you want to delete order ${order.orderNumber}?'),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          getIt<OrderController>().deleteOrder(order);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        )),
      ],
    );
  }
}