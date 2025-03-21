import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_wizard/controller/order_controller.dart';
import 'package:order_wizard/utils/service_locator.dart';
import 'package:go_router/go_router.dart';

class EditOrderScreen extends StatelessWidget {
  const EditOrderScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = getIt<OrderController>();
    final order = orderController.orders.firstWhere((o) => o.orderNumber == orderId);
    
    // Create controllers for editable fields
    final noteController = TextEditingController(text: order.note);
    
    // Create value notifiers for toggle states
    final commentWithPictureNotifier = ValueNotifier<bool>(order.commentWithPicture);
    final commentedNotifier = ValueNotifier<bool>(order.commented);
    final revealedNotifier = ValueNotifier<bool>(order.revealed);
    final reimbursedNotifier = ValueNotifier<bool>(order.reimbursed);

    void saveChanges() {
      final updatedOrder = order.copyWith(
        commentWithPicture: commentWithPictureNotifier.value,
        commented: commentedNotifier.value,
        revealed: revealedNotifier.value,
        reimbursed: reimbursedNotifier.value,
        note: noteController.text,
      );
      orderController.updateOrder(updatedOrder);
      context.pop();
    }

    void deleteOrder() {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Delete Order'),
          content: Text('Are you sure you want to delete order ${order.orderNumber}?'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                orderController.deleteOrder(order);
                Navigator.pop(context); // Close dialog
                context.go('/'); // Go back to list
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
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Edit Order ${order.orderNumber}'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () => context.pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: saveChanges,
          child: const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Order details section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Number: ${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount: \$${order.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Toggles section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: commentWithPictureNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Has Picture', style: TextStyle(fontSize: 17)),
                        CupertinoSwitch(
                          value: value,
                          onChanged: (bool newValue) {
                            commentWithPictureNotifier.value = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<bool>(
                    valueListenable: commentedNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Commented', style: TextStyle(fontSize: 17)),
                        CupertinoSwitch(
                          value: value,
                          onChanged: (bool newValue) {
                            commentedNotifier.value = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<bool>(
                    valueListenable: revealedNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Revealed', style: TextStyle(fontSize: 17)),
                        CupertinoSwitch(
                          value: value,
                          onChanged: (bool newValue) {
                            revealedNotifier.value = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<bool>(
                    valueListenable: reimbursedNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reimbursed', style: TextStyle(fontSize: 17)),
                        CupertinoSwitch(
                          value: value,
                          onChanged: (bool newValue) {
                            reimbursedNotifier.value = newValue;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Note section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Note',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: noteController,
                    placeholder: 'Enter note',
                    maxLines: 4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey4,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Delete button
            CupertinoButton(
              color: CupertinoColors.destructiveRed,
              onPressed: deleteOrder,
              child: const Text('Delete Order'),
            ),
          ],
        ),
      ),
    );
  }
}