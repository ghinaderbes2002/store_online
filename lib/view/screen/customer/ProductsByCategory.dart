import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/customer/product_customer_controller.dart';
import 'package:online_store/core/constant/App_routes.dart';
import 'package:online_store/model/product_model.dart';
import 'package:online_store/view/screen/customer/compare_page.dart';

class ProductsByCategoryPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  ProductsByCategoryPage({super.key})
    : categoryId = Get.arguments['categoryId'],
      categoryName = Get.arguments['categoryName'];

  final ProductCustomerController controller = Get.put(
    ProductCustomerController(),
  );

  @override
  Widget build(BuildContext context) {
    controller.fetchProductsByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
        elevation: 0,
        actions: [
          // زر الفلترة
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: GetBuilder<ProductCustomerController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "لا توجد منتجات في هذا التصنيف",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // شريط البحث
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ابحث عن منتج...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                  ),
                  onChanged: (value) {
                    controller.searchProducts(value);
                  },
                ),
              ),

              // عدد المنتجات
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${controller.products.length} منتج",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // قائمة المنتجات
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return _buildProductCard(product);
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // فتح صفحة اختيار المنتجات للمقارنة
            Get.to(() => const SelectProductsToComparePage());
          },
          icon: const Icon(Icons.compare_arrows_rounded),
          label: const Text(
            "اختر منتجات للمقارنة",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // بطاقة المنتج
  // بطاقة المنتج
  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoute.productDetails,
            arguments: {'productId': product.id},
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 12),

              // تفاصيل المنتج
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // الوصف (إذا موجود)
                    if (product.description != null &&
                        product.description!.isNotEmpty)
                      Text(
                        product.description!,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),

                    // SKU
                    Text(
                      "الرمز: ${product.sku}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),

                    // السعر والمخزون
                    Row(
                      children: [
                        Text(
                          "${(product.priceCents / 100).toStringAsFixed(0)} ل.س",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "المخزون: ${product.stockQty}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // حالة التفعيل
                    Row(
                      children: [
                        Icon(
                          product.isActive ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: product.isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          product.isActive ? "مفعل" : "غير مفعل",
                          style: TextStyle(
                            fontSize: 13,
                            color: product.isActive
                                ? Colors.green
                                : Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // نافذة الفلترة
  void _showFilterBottomSheet(BuildContext context) async {
    await controller.fetchAvailableCompanies(); // جلب الشركات قبل العرض

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GetBuilder<ProductCustomerController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "تصفية المنتجات",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // الفلترة حسب السعر
                  const Text(
                    "الترتيب حسب السعر",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _filterChip(
                        "من الأقل للأعلى",
                        controller.priceFilter == 'asc',
                        () => controller.filterByPrice('asc'),
                      ),
                      _filterChip(
                        "من الأعلى للأقل",
                        controller.priceFilter == 'desc',
                        () => controller.filterByPrice('desc'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // الفلترة حسب الشركة
                  const Text(
                    "الشركة المصنعة",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  if (controller.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (controller.availableCompanies.isEmpty)
                    const Text(
                      "لا توجد شركات متاحة",
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      children: controller.availableCompanies.map((data) {
                        final parts = data.split('|');
                        final brandId = parts.first; // الرقم كـ String
                        final brandName = parts.last; // الاسم للعرض فقط

                        return _filterChip(
                          brandName,
                          controller.selectedCompany == brandId,
                          () {
                            controller.filterByCompany(
                              brandId,
                            ); // هنا مباشرة يستخدم brandId
                          },
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 24),

                  // أزرار التحكم
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.clearFilters();
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("إعادة تعيين"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("تطبيق"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Chip للفلترة
  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue[700],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
