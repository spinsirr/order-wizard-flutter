import 'package:get_it/get_it.dart';
import 'package:order_wizard/controller/order_controller.dart';
import 'package:order_wizard/service/order_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerSingleton<OrderService>(OrderService());
  getIt.registerSingleton<OrderController>(OrderController());
}