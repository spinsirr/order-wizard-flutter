import 'package:flutter/cupertino.dart';
import 'package:order_wizard/controller/order_controller.dart';
import 'package:order_wizard/models/order.dart';
import 'package:order_wizard/utils/service_locator.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:io';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = getIt<OrderController>();
    final formKey = GlobalKey<FormState>();
    final orderNumberController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final ValueNotifier<File?> selectedImage = ValueNotifier<File?>(null);
    final ValueNotifier<bool> isDragging = ValueNotifier<bool>(false);
    final ValueNotifier<bool> commentWithPicture = ValueNotifier<bool>(false);



    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Add New Order'),
      ),
      child: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Image Upload
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder<File?>(
                    valueListenable: selectedImage,
                    builder: (context, image, _) {
                      return Column(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: isDragging,
                            builder: (context, dragging, _) {
                              return DropTarget(
                                onDragDone: (details) {
                                  if (details.files.isNotEmpty) {
                                    selectedImage.value = File(details.files.first.path);
                                  }
                                },
                                onDragEntered: (details) => isDragging.value = true,
                                onDragExited: (details) => isDragging.value = false,
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: dragging ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: dragging ? CupertinoColors.activeBlue.withOpacity(0.1) : null,
                                  ),
                                  child: image != null
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(image, fit: BoxFit.cover),
                                          Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: CupertinoColors.black.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'Drop new image here\nto replace',
                                                style: TextStyle(color: CupertinoColors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.photo,
                                            size: 48,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            dragging ? 'Release to upload' : 'Drop image here',
                                            style: const TextStyle(
                                              color: CupertinoColors.systemGrey,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: CupertinoColors.systemGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ValueListenableBuilder<bool>(
                              valueListenable: commentWithPicture,
                              builder: (context, value, _) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Comment with Picture',
                                    style: TextStyle(
                                      color: CupertinoColors.label,
                                      fontSize: 16,
                                    ),
                                  ),
                                  CupertinoSwitch(
                                    value: value,
                                    onChanged: (newValue) {
                                      commentWithPicture.value = newValue;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Right side - Order Details
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CupertinoTextField(
                        controller: orderNumberController,
                        placeholder: 'Order Number',
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.systemGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      const SizedBox(height: 16),

                      CupertinoTextField(
                        controller: amountController,
                        placeholder: 'Amount',
                        padding: const EdgeInsets.all(12),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.systemGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      const SizedBox(height: 16),

                      CupertinoTextField(
                        controller: noteController,
                        placeholder: 'Note',
                        padding: const EdgeInsets.all(12),
                        maxLines: 3,
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.systemGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      const SizedBox(height: 24),

                      CupertinoButton.filled(
                        onPressed: () {
                          if (orderNumberController.text.isEmpty) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('Invalid Input'),
                                content: const Text('Please enter an order number.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          final amount = double.tryParse(amountController.text);
                          if (amount == null || amount <= 0) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('Invalid Input'),
                                content: const Text('Please enter a valid amount greater than 0.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          final order = Order(
                            orderNumber: orderNumberController.text,
                            amount: amount,
                            imageUri: selectedImage.value?.path,
                            note: noteController.text,
                            commentWithPicture: commentWithPicture.value,
                          );
                          orderController.addOrder(order);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Add Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}