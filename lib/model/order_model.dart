import 'order_item_model.dart';
import 'user_model.dart';

enum OrderStatus { PLACED, CONFIRMED, SHIPPED, DELIVERED, CANCELLED }

class OrderModel {
  final int id;
  final int? customerId;
  final int subtotalCents;
  final int discountCents;
  final int totalCents;
  final String paymentMethod;
  OrderStatus status;
  final DateTime createdAt;
  final UserModel? customer;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    this.customerId,
    required this.subtotalCents,
    required this.discountCents,
    required this.totalCents,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.customer,
    required this.items,
  });
factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.parse(json['id'].toString()),

      customerId: json['customerId'] != null
          ? int.tryParse(json['customerId'].toString())
          : null,

      subtotalCents:
          int.tryParse(json['subtotalCents']?.toString() ?? '0') ?? 0,
      discountCents:
          int.tryParse(json['discountCents']?.toString() ?? '0') ?? 0,
      totalCents: int.tryParse(json['totalCents']?.toString() ?? '0') ?? 0,

      paymentMethod: json['paymentMethod']?.toString() ?? 'COD',

      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.PLACED,
      ),

      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),

      customer: json['customer'] != null
          ? UserModel.fromJson(json['customer'])
          : null,

      items: (json['items'] is List)
          ? (json['items'] as List)
                .map((e) => OrderItemModel.fromJson(e))
                .toList()
          : [],
    );
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'subtotalCents': subtotalCents,
    'discountCents': discountCents,
    'totalCents': totalCents,
    'paymentMethod': paymentMethod,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'customer': customer?.toJson(),
    'items': items.map((e) => e.toJson()).toList(),
  };
}
