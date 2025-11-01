import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/owner/order_controller.dart';
import 'package:online_store/model/order_model.dart';

class OrdersPage extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());

  OrdersPage({super.key});

  final List<OrderStatus> statuses = [
    OrderStatus.PLACED,
    OrderStatus.CONFIRMED,
    OrderStatus.SHIPPED,
    OrderStatus.DELIVERED,
    OrderStatus.CANCELLED,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "لا يوجد طلبات",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "لم يتم تقديم أي طلبات بعد",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final OrderModel order = controller.orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header الطلب
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getStatusColor(order.status).withOpacity(0.1),
                            _getStatusColor(order.status).withOpacity(0.05),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                order.status,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.receipt_long_rounded,
                              color: _getStatusColor(order.status),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
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
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      order.customer?.name ??
                                          "زبون #${order.customerId}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusTextArabic(order.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // تفاصيل الطلب
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // المجموع
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.green.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "المجموع الكلي:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${(order.totalCents / 100).toStringAsFixed(2)} \$",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // عنوان تغيير الحالة
                          Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "تغيير حالة الطلب:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // أزرار الحالات
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: statuses.map((status) {
                              final isSelected = order.status == status;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    controller.updateOrderStatus(order, status);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _getStatusColor(status)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? _getStatusColor(status)
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getStatusIcon(status),
                                          size: 16,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          _getStatusTextArabic(status),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                            fontSize: 13,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PLACED:
        return Colors.blue;
      case OrderStatus.CONFIRMED:
        return Colors.orange;
      case OrderStatus.SHIPPED:
        return Colors.purple;
      case OrderStatus.DELIVERED:
        return Colors.green;
      case OrderStatus.CANCELLED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusTextArabic(OrderStatus status) {
    switch (status) {
      case OrderStatus.PLACED:
        return "تم الطلب";
      case OrderStatus.CONFIRMED:
        return "مؤكد";
      case OrderStatus.SHIPPED:
        return "قيد الشحن";
      case OrderStatus.DELIVERED:
        return "تم التوصيل";
      case OrderStatus.CANCELLED:
        return "ملغي";
      default:
        return status.name;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.PLACED:
        return Icons.assignment_outlined;
      case OrderStatus.CONFIRMED:
        return Icons.check_circle_outline;
      case OrderStatus.SHIPPED:
        return Icons.local_shipping_outlined;
      case OrderStatus.DELIVERED:
        return Icons.done_all;
      case OrderStatus.CANCELLED:
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
