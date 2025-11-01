import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/customer/category_customer_controller.dart';
import 'package:online_store/core/constant/App_routes.dart';

class CategoriesPage extends StatelessWidget {
  final CategoryCustomerController controller = Get.put(
    CategoryCustomerController(),
  );

  CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التصنيفات"),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<CategoryCustomerController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "لا توجد تصنيفات بعد",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // فلترة التصنيفات النشطة فقط
          final activeCategories = controller.categories
              .where((category) => category.isActive)
              .toList();

          if (activeCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "لا توجد تصنيفات متاحة حالياً",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عمودين
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1, // مربعات متساوية
              ),
              itemCount: activeCategories.length,
              itemBuilder: (context, index) {
                final category = activeCategories[index];

                // ألوان متنوعة للبطاقات
                final colors = [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.teal,
                  Colors.pink,
                  Colors.indigo,
                  Colors.amber,
                ];
                final color = colors[index % colors.length];

                return InkWell(
                  onTap: () {
                    // الانتقال لصفحة منتجات التصنيف
                    Get.toNamed(
                      AppRoute.productsBycategory,
                      arguments: {
                        'categoryId': category.id,
                        'categoryName': category.name,
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.shade400, color.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // أيقونة التصنيف
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.category,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // اسم التصنيف
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
