import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String orderNumber,
    required double amount,
    String? imageUri,
    @Default(false) bool commentWithPicture,
    @Default(false) bool commented,
    @Default(false) bool revealed,
    @Default(false) bool reimbursed,
    @Default(0.0) double reimbursedAmount,
    String? note,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
