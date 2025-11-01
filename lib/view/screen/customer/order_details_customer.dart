import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_store/model/order_model.dart';
import 'package:online_store/model/order_item_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsPage({super.key, required this.order});

  // دالة ترجمة حالة الطلب للعربي
  String getStatusArabic(OrderModel order) {
    switch (order.status) {
      case OrderStatus.PLACED:
        return 'تم الطلب';
      case OrderStatus.CONFIRMED:
        return 'تم التأكيد';
      case OrderStatus.SHIPPED:
        return 'تم الشحن';
      case OrderStatus.DELIVERED:
        return 'تم التوصيل';
      case OrderStatus.CANCELLED:
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'yyyy-MM-dd – HH:mm',
    ).format(order.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الطلب"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // معلومات الطلب العامة
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "طلب #${order.id}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "الحالة: ${getStatusArabic(order)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "تاريخ الطلب: $formattedDate",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "طريقة الدفع: ${order.paymentMethod}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "الإجمالي: ${(order.totalCents / 100).toStringAsFixed(0)} ل.س",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // المنتجات
            Text(
              "المنتجات",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...order.items.map((item) => _buildProductCard(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(OrderItemModel item) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nameSnapshot,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "SKU: ${item.skuSnapshot}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "سعر الوحدة: ${(item.unitPriceCents / 100).toStringAsFixed(0)} ل.س",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "الكمية: ${item.qty}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              "${(item.lineTotalCents / 100).toStringAsFixed(0)} ل.س",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
