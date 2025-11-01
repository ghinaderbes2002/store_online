import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/auth/login_controller.dart';
import 'package:online_store/controllers/customer/category_customer_controller.dart';
import 'package:online_store/controllers/customer/offer_customer_controller.dart';
import 'package:online_store/controllers/customer/product_customer_controller.dart';
import 'package:online_store/controllers/customer/order_customer_controller.dart';
import 'package:online_store/view/screen/customer/ProductsByCategory.dart';
import 'package:online_store/view/screen/customer/categories_page.dart';
import 'package:online_store/view/screen/customer/offer_details_page.dart';
import 'package:online_store/view/screen/customer/orders_customer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Controllers
  final CategoryCustomerController categoryController = Get.put(
    CategoryCustomerController(),
  );
  final ProductCustomerController productController = Get.put(
    ProductCustomerController(),
  );
  final OrderCustomerController orderController = Get.put(
    OrderCustomerController(),
  );
  final OfferCustomerController offerController = Get.put(
    OfferCustomerController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "الرئيسية",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 بطاقة الترحيب
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.waving_hand_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "مرحباً بك!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "اكتشف منتجاتنا وعروضنا المميزة 🎁",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 التصنيفات
            _buildSectionHeader(
              title: "التصنيفات",
              icon: Icons.category_rounded,
              color: Colors.blue.shade700,
              onViewAll: () => Get.to(() => CategoriesPage()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: GetBuilder<CategoryCustomerController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.categories.isEmpty) {
                    return _emptyState(
                      icon: Icons.category_outlined,
                      text: "لا توجد تصنيفات",
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ProductsByCategoryPage(),
                            arguments: {
                              'categoryId': category.id,
                              'categoryName': category.name,
                            },
                          );
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: Colors.blue.shade700,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                category.name ?? "بدون اسم",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // 🔹 العروض الخاصة
            _buildSectionHeader(
              title: "العروض الخاصة",
              icon: Icons.local_offer_rounded,
              color: Colors.pink.shade700,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: GetBuilder<OfferCustomerController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.offers.isEmpty) {
                    return _emptyState(
                      icon: Icons.local_offer_outlined,
                      text: "لا توجد عروض حالياً",
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.offers.length,
                    itemBuilder: (context, index) {
                      final offer = controller.offers[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => OfferDetailsPage(),
                            arguments: {'offer': offer},
                          );
                        },
                        child: Container(
                          width: 280,
                          margin: const EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink.shade400,
                                Colors.pink.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "عرض خاص 🎉",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  offer.name ?? "بدون عنوان",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  offer.type == "PERCENT"
                                      ? "خصم ${offer.value}%"
                                      : "خصم ${offer.value} ل.س",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // 🔹 بطاقة طلباتي
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () => Get.to(() => OrdersPage()),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.purple.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "طلباتي",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "عرض جميع طلباتك السابقة بسهولة",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔸 ويدجت ثابتة لعنوان القسم
  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    VoidCallback? onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: onViewAll != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (onViewAll != null)
            TextButton.icon(
              onPressed: onViewAll,
              icon: const Icon(Icons.arrow_forward_ios, size: 14),
              label: const Text("عرض الكل"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  // 🔸 ويدجت لعرض حالة عدم وجود بيانات
  Widget _emptyState({required IconData icon, required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
