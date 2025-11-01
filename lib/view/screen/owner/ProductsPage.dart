import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/owner/category_controller.dart';
import 'package:online_store/controllers/owner/brand_controller.dart';
import 'package:online_store/controllers/owner/product_controller.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final productController = Get.put(ProductController());
  final categoryController = Get.put(CategoryController());
  final brandController = Get.put(BrandController());

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategories();
    brandController.fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // قسم الإضافة مع ارتفاع محدد
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5, // نصف الشاشة
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "إضافة منتج جديد",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // اسم المنتج
                          TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              labelText: "اسم المنتج",
                              hintText: "أدخل اسم المنتج",
                              prefixIcon: const Icon(
                                Icons.shopping_bag_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "مطلوب" : null,
                          ),
                          const SizedBox(height: 12),

                          // SKU
                          TextFormField(
                            controller: controller.skuController,
                            decoration: InputDecoration(
                              labelText: "رمز المنتج (SKU)",
                              hintText: "مثال: PRD-001",
                              prefixIcon: const Icon(Icons.qr_code_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (val) =>
                                val == null || val.isEmpty ? "مطلوب" : null,
                          ),
                          const SizedBox(height: 12),

                          // السعر والكمية
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controller.priceController,
                                  decoration: InputDecoration(
                                    labelText: "السعر",
                                    hintText: "0",
                                    prefixIcon: const Icon(Icons.attach_money),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.orange,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.stockController,
                                  decoration: InputDecoration(
                                    labelText: "الكمية",
                                    hintText: "0",
                                    prefixIcon: const Icon(
                                      Icons.inventory_2_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Colors.orange,
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // قسم الميزات
                          Text(
                            "الميزات",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.ramController,
                            decoration: _buildFeatureInputDecoration("RAM"),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.storageController,
                            decoration: _buildFeatureInputDecoration("Storage"),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.colorController,
                            decoration: _buildFeatureInputDecoration("Color"),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.displayController,
                            decoration: _buildFeatureInputDecoration("Display"),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.batteryController,
                            decoration: _buildFeatureInputDecoration("Battery"),
                          ),
                          const SizedBox(height: 12),

                          // Dropdown والفئة والشركة
                          GetBuilder<CategoryController>(
                            builder: (catController) {
                              if (catController.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: "الصنف",
                                  prefixIcon: const Icon(
                                    Icons.category_outlined,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: controller.categoryId,
                                items: catController.categories
                                    .map(
                                      (cat) => DropdownMenuItem<int>(
                                        value: cat.id,
                                        child: Text(cat.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  controller.categoryId = val;
                                  controller.update();
                                },
                                validator: (val) =>
                                    val == null ? "الرجاء اختيار فئة" : null,
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          GetBuilder<BrandController>(
                            builder: (brandCtrl) {
                              if (brandCtrl.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: "الشركة",
                                  prefixIcon: const Icon(
                                    Icons.business_outlined,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                value: controller.brandId,
                                items: brandCtrl.brands
                                    .map(
                                      (b) => DropdownMenuItem<int>(
                                        value: b.id,
                                        child: Text(b.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  controller.brandId = val;
                                  controller.update();
                                },
                                validator: (val) =>
                                    val == null ? "الرجاء اختيار شركة" : null,
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Switch للحالة
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: SwitchListTile(
                              value: controller.isActive,
                              title: const Text(
                                "حالة المنتج",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                controller.isActive ? "نشط" : "غير نشط",
                                style: TextStyle(
                                  color: controller.isActive
                                      ? Colors.green
                                      : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              activeColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onChanged: (val) {
                                controller.isActive = val;
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // زر الإضافة
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: controller.createProduct,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text(
                                "إضافة المنتج",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // قسم القائمة
              Expanded(
                child: controller.products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "لا توجد منتجات",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "قم بإضافة منتج جديد من الأعلى",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.products.length,
                        itemBuilder: (context, index) {
                          final product = controller.products[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: product.isActive
                                      ? Colors.orange.shade50
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.shopping_bag_rounded,
                                  color: product.isActive
                                      ? Colors.orange.shade700
                                      : Colors.grey.shade600,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    _buildInfoChip(
                                      Icons.attach_money,
                                      "${product.priceCents} سنت",
                                      Colors.green,
                                    ),
                                    _buildInfoChip(
                                      Icons.inventory_2,
                                      "الكمية: ${product.stockQty}",
                                      Colors.purple,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: product.isActive
                                            ? Colors.green.shade50
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            product.isActive
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            size: 14,
                                            color: product.isActive
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            product.isActive
                                                ? "نشط"
                                                : "غير نشط",
                                            style: TextStyle(
                                              color: product.isActive
                                                  ? Colors.green.shade700
                                                  : Colors.grey.shade600,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        controller.updateProduct(product);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        controller.deleteProduct(product);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _buildFeatureInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.list_alt_outlined),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orange, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
