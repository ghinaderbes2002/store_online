import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/owner/category_controller.dart';
import 'package:online_store/controllers/owner/brand_controller.dart';
import 'package:online_store/controllers/owner/product_controller.dart';
import 'package:online_store/model/product_model.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddProductDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text("إضافة منتج"),
        backgroundColor: Colors.blue,
      ),
      body: GetBuilder<ProductController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
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
                              contentPadding: const EdgeInsets.all(12),
                              leading:
                                  product.imageUrl != null &&
                                      product.imageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.imageUrl!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.shopping_bag_rounded,
                                        color: product.isActive
                                            ? Colors.green.shade700
                                            : Colors.grey.shade600,
                                        size: 30,
                                      ),
                                    ),
                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.description != null &&
                                      product.description!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        product.description!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Wrap(
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
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
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
                                ],
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
                                        _showEditProductDialog(
                                          context,
                                          product,
                                        );
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

  void _showEditProductDialog(BuildContext context, ProductModel product) {
    final productController = Get.find<ProductController>();

    // ✅ تعبئة الحقول بالبيانات الحالية
    productController.nameController.text = product.name;
    productController.skuController.text = product.sku;
    productController.priceController.text = product.priceCents.toString();
    productController.stockController.text = product.stockQty.toString();
    productController.categoryId = product.categoryId;
    productController.brandId = product.brandId;
    productController.isActive = product.isActive;

    productController.ramController.text = product.features?['RAM'] ?? '';
    productController.storageController.text =
        product.features?['Storage'] ?? '';
    productController.colorController.text = product.features?['Color'] ?? '';
    productController.displayController.text =
        product.features?['Display'] ?? '';
    productController.batteryController.text =
        product.features?['Battery'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: productController.formState,
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
                          Icons.edit_outlined,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "تعديل المنتج",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 🔹 نفس الحقول المستخدمة في الإضافة:
                  TextFormField(
                    controller: productController.nameController,
                    decoration: const InputDecoration(
                      labelText: "اسم المنتج",
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "مطلوب" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: productController.skuController,
                    decoration: const InputDecoration(
                      labelText: "رمز المنتج (SKU)",
                      prefixIcon: Icon(Icons.qr_code_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: productController.priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "السعر",
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: productController.stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "الكمية",
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ✅ Dropdown الصنف
                  GetBuilder<CategoryController>(
                    builder: (catCtrl) {
                      return DropdownButtonFormField<int>(
                        value: productController.categoryId,
                        decoration: const InputDecoration(
                          labelText: "الصنف",
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: catCtrl.categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          productController.categoryId = val;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // ✅ Dropdown الشركة
                  GetBuilder<BrandController>(
                    builder: (brandCtrl) {
                      return DropdownButtonFormField<int>(
                        value: productController.brandId,
                        decoration: const InputDecoration(
                          labelText: "الشركة",
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        items: brandCtrl.brands
                            .map(
                              (b) => DropdownMenuItem(
                                value: b.id,
                                child: Text(b.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          productController.brandId = val;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // ✅ الحالة
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: GetBuilder<ProductController>(
                      builder: (controller) {
                        return SwitchListTile(
                          value: controller.isActive,
                          title: const Text("حالة المنتج"),
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
                          onChanged: (val) {
                            controller.isActive = val;
                            controller.update();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ زر التحديث
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (productController.formState.currentState!
                            .validate()) {
                          // تحديث القيم في الموديل
                          final updatedProduct = product.copyWith(
                            name: productController.nameController.text,
                            sku: productController.skuController.text,
                            priceCents:
                                int.tryParse(
                                  productController.priceController.text,
                                ) ??
                                0,
                            stockQty:
                                int.tryParse(
                                  productController.stockController.text,
                                ) ??
                                0,
                            categoryId: productController.categoryId,
                            brandId: productController.brandId,
                            isActive: productController.isActive,
                            features: {
                              'RAM': productController.ramController.text,
                              'Storage':
                                  productController.storageController.text,
                              'Color': productController.colorController.text,
                              'Display':
                                  productController.displayController.text,
                              'Battery':
                                  productController.batteryController.text,
                            },
                          );

                          await productController.saveUpdatedProduct(
                            updatedProduct,
                          );
                          Navigator.pop(context);
                        }
                      },

                      icon: const Icon(Icons.save),
                      label: const Text("تحديث"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final productController = Get.find<ProductController>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: productController.formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue.shade700,
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

                  // 🟠 حقول أساسية
                  TextFormField(
                    controller: productController.nameController,
                    decoration: InputDecoration(
                      labelText: "اسم المنتج",
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? "مطلوب" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: productController.skuController,
                    decoration: InputDecoration(
                      labelText: "رمز المنتج (SKU)",
                      prefixIcon: const Icon(Icons.qr_code_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: productController.descriptionController,
                    decoration: InputDecoration(
                      labelText: " الوصف ",
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: productController.priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "السعر",
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: productController.stockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "الكمية",
                            prefixIcon: const Icon(Icons.inventory_2_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ✅ Dropdown الفئة
                  GetBuilder<CategoryController>(
                    builder: (catCtrl) {
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "الصنف",
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: catCtrl.categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          productController.categoryId = val;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // ✅ Dropdown الشركة
                  GetBuilder<BrandController>(
                    builder: (brandCtrl) {
                      return DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "الشركة",
                          prefixIcon: const Icon(Icons.business_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: brandCtrl.brands
                            .map(
                              (b) => DropdownMenuItem(
                                value: b.id,
                                child: Text(b.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          productController.brandId = val;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 🧩 الميزات
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
                    controller: productController.ramController,
                    decoration: _buildFeatureInputDecoration("RAM"),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: productController.storageController,
                    decoration: _buildFeatureInputDecoration("Storage"),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: productController.colorController,
                    decoration: _buildFeatureInputDecoration("Color"),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: productController.displayController,
                    decoration: _buildFeatureInputDecoration("Display"),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: productController.batteryController,
                    decoration: _buildFeatureInputDecoration("Battery"),
                  ),

                  const SizedBox(height: 16),

                  // 🟢 حالة المنتج
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: GetBuilder<ProductController>(
                      builder: (controller) {
                        return SwitchListTile(
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
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: productController.pickImage,
                    child: const Text("اختر صورة"),
                  ),
                  const SizedBox(height: 16),

                  // 🔘 زر الإضافة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        productController.createProduct();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("إضافة"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
