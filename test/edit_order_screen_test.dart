import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_wizard/controller/order_controller.dart';
import 'package:order_wizard/models/order.dart';
import 'package:order_wizard/ui/edit_order_screen.dart';
import 'package:order_wizard/utils/service_locator.dart';
import 'package:get_it/get_it.dart';

void main() {
  late OrderController mockOrderController;
  const testOrder = Order(
    orderNumber: 'TEST001',
    amount: 99.99,
    note: 'Test note',
    commentWithPicture: false,
    commented: false,
    revealed: false,
    reimbursed: false,
  );

  setUp(() {
    mockOrderController = OrderController();
    mockOrderController.addOrder(testOrder);
    GetIt.I.registerSingleton<OrderController>(mockOrderController);
  });

  tearDown(() {
    GetIt.I.unregister<OrderController>();
  });

  testWidgets('EditOrderScreen displays order details correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: EditOrderScreen(orderId: 'TEST001'),
      ),
    );

    // Verify order details are displayed
    expect(find.text('Edit Order TEST001'), findsOneWidget);
    expect(find.text('Order Number: TEST001'), findsOneWidget);
    expect(find.text('Amount: \$99.99'), findsOneWidget);
    expect(find.text('Test note'), findsOneWidget);

    // Verify all toggles are present
    expect(find.text('Has Picture'), findsOneWidget);
    expect(find.text('Commented'), findsOneWidget);
    expect(find.text('Revealed'), findsOneWidget);
    expect(find.text('Reimbursed'), findsOneWidget);

    // Verify all switches are in initial state (false)
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(0)).value, false);
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(1)).value, false);
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(2)).value, false);
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(3)).value, false);
  });

  testWidgets('EditOrderScreen toggles update correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: EditOrderScreen(orderId: 'TEST001'),
      ),
    );

    // Toggle each switch
    await tester.tap(find.byType(CupertinoSwitch).at(0));
    await tester.pump();
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(0)).value, true);

    await tester.tap(find.byType(CupertinoSwitch).at(1));
    await tester.pump();
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(1)).value, true);

    await tester.tap(find.byType(CupertinoSwitch).at(2));
    await tester.pump();
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(2)).value, true);

    await tester.tap(find.byType(CupertinoSwitch).at(3));
    await tester.pump();
    expect(tester.widget<CupertinoSwitch>(find.byType(CupertinoSwitch).at(3)).value, true);
  });

  testWidgets('EditOrderScreen note editing works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: EditOrderScreen(orderId: 'TEST001'),
      ),
    );

    // Find and edit the note field
    final noteField = find.byType(CupertinoTextField);
    await tester.enterText(noteField, 'Updated note');
    expect(find.text('Updated note'), findsOneWidget);
  });

  testWidgets('EditOrderScreen delete confirmation shows and works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: EditOrderScreen(orderId: 'TEST001'),
      ),
    );

    // Tap delete button
    await tester.tap(find.text('Delete Order'));
    await tester.pump();

    // Verify confirmation dialog
    expect(find.text('Delete Order'), findsOneWidget);
    expect(find.text('Are you sure you want to delete order TEST001?'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap cancel and verify order still exists
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(mockOrderController.orders.length, 1);

    // Tap delete again and confirm
    await tester.tap(find.text('Delete Order'));
    await tester.pump();
    await tester.tap(find.text('Delete').last);
    await tester.pump();
    expect(mockOrderController.orders.isEmpty, true);
  });
} 