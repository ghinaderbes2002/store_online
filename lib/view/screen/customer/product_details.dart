import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/customer/order_customer_controller.dart';
import 'package:online_store/controllers/customer/product_customer_controller.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/model/product_model.dart';
import 'package:online_store/view/screen/customer/orders_customer.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({super.key});

  final ProductCustomerController controller = Get.put(
    ProductCustomerController(),
  );

  @override
  Widget build(BuildContext context) {
    final int productId = Get.arguments['productId'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductDetails(productId);
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "تفاصيل المنتج",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<ProductCustomerController>(
        builder: (controller) {
          if (controller.isLoadingProductDetails) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.productDetails == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "لا توجد بيانات للمنتج",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final ProductModel product = controller.productDetails!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // بطاقة المنتج الرئيسية
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // اسم المنتج
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // السعر الكبير
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "السعر",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${(product.priceCents / 100).toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "ل.س",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // بطاقة المعلومات
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.inventory_2_outlined,
                                "الكمية المتوفرة",
                                "${product.stockQty} قطعة",
                                product.stockQty > 10
                                    ? Colors.green
                                    : product.stockQty > 0
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                              const Divider(height: 24),
                              _buildInfoRow(
                                product.isActive
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                "حالة المنتج",
                                product.isActive ? "متوفر" : "غير متوفر",
                                product.isActive ? Colors.green : Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // المواصفات
                      if (product.features != null &&
                          product.features!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildFeaturesSection(product),
                        ),
                    ],
                  ),
                ),
              ),

              // شريط الأسفل
              _buildBottomBar(product),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.blue.shade700,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              "المواصفات",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: product.features!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ProductModel product) {
    int quantity = 1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // اختيار الكمية
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        icon: Icon(
                          Icons.remove_circle,
                          color: quantity > 1
                              ? Colors.red.shade600
                              : Colors.grey.shade400,
                          size: 36,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: quantity < product.stockQty
                            ? () {
                                setState(() {
                                  quantity++;
                                });
                              }
                            : null,
                        icon: Icon(
                          Icons.add_circle,
                          color: quantity < product.stockQty
                              ? Colors.green.shade600
                              : Colors.grey.shade400,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // السعر + زر الطلب
                Row(
                  children: [
                    // السعر
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "الإجمالي",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${((product.priceCents * quantity) / 100).toStringAsFixed(0)} ل.س",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // زر الطلب
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: product.stockQty > 0 && product.isActive
                              ? () async {
                                  final OrderCustomerController
                                  orderController = Get.put(
                                    OrderCustomerController(),
                                  );

                                  final items = [
                                    {"productId": product.id, "qty": quantity},
                                  ];

                                  final result = await orderController
                                      .placeOrder(items: items);

                                 if (result == Staterequest.success) {
                                    Get.snackbar(
                                      "نجاح",
                                      "تم إرسال طلبك بنجاح 🎉",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    );

                                    // 🔹 الانتقال إلى صفحة الطلبات بعد ثانيتين
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        Get.off(() => OrdersPage());
                                      },
                                    );
                                  } else {
                                    Get.snackbar(
                                      "خطأ",
                                      "فشل إرسال الطلب. حاول مرة أخرى.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                    );
                                  }

                                }
                              : null,
                          icon: const Icon(Icons.shopping_cart, size: 22),
                          label: const Text(
                            "اطلب الآن",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
