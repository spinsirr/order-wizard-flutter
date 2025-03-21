import 'package:flutter/material.dart';
import 'package:order_wizard/models/order.dart';
import 'package:order_wizard/service/order_service.dart';
import 'package:order_wizard/utils/service_locator.dart';

class OrderController extends ChangeNotifier  {
  final List<Order> _orders = [];
  final OrderService _orderService = getIt<OrderService>();

  final ValueNotifier<bool> _commentWithPictureNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _commentedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _revealedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _reimbursedNotifier = ValueNotifier<bool>(false);

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    _orderService.addOrder(order);
    notifyListeners();
  }

  void updateOrder(Order order) {
    _orders.add(order);
    _orderService.updateOrder(order);
    notifyListeners();
  }

  void deleteOrder(Order order) {
    _orders.remove(order);
    _orderService.deleteOrder(order);
    notifyListeners();
  }

  Future<void> getOrders() async {
    _orders.clear();
    _orders.addAll(await _orderService.getOrders());
    notifyListeners();
  } 

  Future<void> toggleCommentWithPicture(bool value) async {
    _commentWithPictureNotifier.value = value;
    notifyListeners();
  } 

  Future<void> toggleCommented(bool value) async {
    _commentedNotifier.value = value;
    notifyListeners();
  } 

  Future<void> toggleRevealed(bool value) async {
    _revealedNotifier.value = value;
    notifyListeners();
  }   

  Future<void> toggleReimbursed(bool value) async {
    _reimbursedNotifier.value = value;
    notifyListeners();
  } 

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}

