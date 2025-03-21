import 'package:flutter/cupertino.dart';
import 'package:order_wizard/controller/order_controller.dart';
import 'package:order_wizard/models/order.dart';
import 'package:order_wizard/utils/service_locator.dart';
import 'package:image_picker/image_picker.dart';
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

    Future<void> pickImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    }

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
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: CupertinoColors.systemGrey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: image != null
                              ? Image.file(image, fit: BoxFit.cover)
                              : const Center(child: Text('No Image')),
                          ),
                          const SizedBox(height: 8),
                          CupertinoButton(
                            onPressed: pickImage,
                            child: Text(image == null ? 'Upload Image' : 'Change Image'),
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
                          if (formKey.currentState?.validate() ?? false) {
                            final amount = double.tryParse(amountController.text) ?? 0.0;
                            final order = Order(
                              orderNumber: orderNumberController.text,
                              amount: amount,
                              imageUri: selectedImage.value?.path,
                              note: noteController.text,
                            );
                            orderController.addOrder(order);
                            Navigator.of(context).pop();
                          }
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