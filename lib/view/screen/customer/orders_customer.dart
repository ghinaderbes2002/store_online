import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_store/controllers/customer/order_customer_controller.dart';
import 'package:online_store/model/order_model.dart';
import 'package:online_store/view/screen/customer/order_details_customer.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  final OrderCustomerController controller = Get.put(OrderCustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلباتي"),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<OrderCustomerController>(
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
                    Icons.receipt_long_rounded,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "لا توجد طلبات حتى الآن",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
              return _buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  String getOrderStatusArabic(OrderStatus status) {
    switch (status) {
      case OrderStatus.PLACED:
        return "تم الطلب";
      case OrderStatus.CONFIRMED:
        return "مؤكد";
      case OrderStatus.SHIPPED:
        return "تم الشحن";
      case OrderStatus.DELIVERED:
        return "تم التوصيل";
      case OrderStatus.CANCELLED:
        return "ملغي";
      default:
        return "-";
    }
  }

 Widget _buildOrderCard(OrderModel order) {
    final formattedDate = DateFormat(
      'yyyy-MM-dd – HH:mm',
    ).format(order.createdAt);

    // دوال الحالة، اللون، والأيقونة كما هي
    String getStatusArabic(OrderStatus status) {
      switch (status) {
        case OrderStatus.PLACED:
          return "تم الطلب";
        case OrderStatus.CONFIRMED:
          return "مؤكد";
        case OrderStatus.SHIPPED:
          return "تم الشحن";
        case OrderStatus.DELIVERED:
          return "تم التوصيل";
        case OrderStatus.CANCELLED:
          return "ملغي";
        default:
          return "-";
      }
    }

    Color getStatusColor(OrderStatus status) {
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

    IconData getStatusIcon(OrderStatus status) {
      switch (status) {
        case OrderStatus.PLACED:
          return Icons.shopping_bag_outlined;
        case OrderStatus.CONFIRMED:
          return Icons.check_circle_outline;
        case OrderStatus.SHIPPED:
          return Icons.local_shipping_outlined;
        case OrderStatus.DELIVERED:
          return Icons.done_all;
        case OrderStatus.CANCELLED:
          return Icons.cancel_outlined;
        default:
          return Icons.timelapse_outlined;
      }
    }

    final statusColor = getStatusColor(order.status);
    final statusIcon = getStatusIcon(order.status);
    final statusArabic = getStatusArabic(order.status);

    return InkWell(
  onTap: () async {
        // جلب تفاصيل الطلب مع المنتجات
        final controller = Get.find<OrderCustomerController>();
        await controller.fetchOrderDetails(order.id);

        if (controller.selectedOrder != null) {
          // فتح صفحة تفاصيل الطلب مع البيانات الكاملة
          Get.to(() => OrderDetailsPage(order: controller.selectedOrder!));
        } else {
          // خطأ أو لا توجد بيانات
          Get.snackbar("خطأ", "فشل جلب تفاصيل الطلب");
        }
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // الحالة والأيقونة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 28),
              ),
              const SizedBox(width: 16),

              // التفاصيل
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
                    const SizedBox(height: 6),
                    Text(
                      "الحالة: $statusArabic",
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "التاريخ: $formattedDate",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // السعر
              Text(
                "${(order.totalCents / 100).toStringAsFixed(0)} ل.س",
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
    );
  }

}
