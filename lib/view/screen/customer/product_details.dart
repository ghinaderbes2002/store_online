import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/customer/order_customer_controller.dart';
import 'package:online_store/controllers/customer/product_customer_controller.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            "تفاصيل المنتج",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Get.back(),
            ),
          ],
        ),
        body: GetBuilder<ProductCustomerController>(
          builder: (controller) {
            if (controller.isLoadingProductDetails) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            if (controller.productDetails == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "لا توجد بيانات للمنتج",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
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
                        const SizedBox(height: 20),

                        // بطاقة المنتج الرئيسية
                        // بطاقة المنتج الرئيسية
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // صورة المنتج
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child:
                                    product.imageUrl != null &&
                                        product.imageUrl!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          "${ServerConfig().serverLink}${product.imageUrl!}", // دمج السيرفر مع المسار
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.shopping_bag,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                              ),
                              const SizedBox(height: 20),

                              // اسم المنتج
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // الوصف
                              if (product.description != null &&
                                  product.description!.isNotEmpty)
                                Text(
                                  product.description!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              const SizedBox(height: 20),

                              // السعر
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${(product.priceCents / 100).toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        "ل.س",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // بطاقة المعلومات
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
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
                                      ? Colors.blue
                                      : product.stockQty > 0
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Divider(color: Colors.grey.shade200, height: 1),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  product.isActive
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  "حالة المنتج",
                                  product.isActive ? "متوفر" : "غير متوفر",
                                  product.isActive ? Colors.blue : Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // المواصفات
                        if (product.features != null &&
                            product.features!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildFeaturesSection(product),
                          ),

                        const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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
            const Icon(Icons.checklist_rounded, color: Colors.blue, size: 22),
            const SizedBox(width: 10),
            const Text(
              "المواصفات",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
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
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: product.features!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                color: Colors.black.withOpacity(0.08),
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
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
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
                          Icons.remove_circle_rounded,
                          color: quantity > 1
                              ? Colors.red.shade400
                              : Colors.grey.shade300,
                          size: 32,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
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
                          Icons.add_circle_rounded,
                          color: quantity < product.stockQty
                              ? Colors.blue
                              : Colors.grey.shade300,
                          size: 32,
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
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "الإجمالي",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${((product.priceCents * quantity) / 100).toStringAsFixed(0)} ل.س",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
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
                                      backgroundColor: Colors.blue,
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 12,
                                      icon: const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                      ),
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
                                        Icons.error_rounded,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                }
                              : null,
                          icon: const Icon(
                            Icons.shopping_cart_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            "اطلب الآن",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
