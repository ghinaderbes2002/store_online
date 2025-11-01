import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/compare_controller.dart';
import 'package:online_store/controllers/customer/product_customer_controller.dart';
import 'package:online_store/model/product_model.dart';
import 'package:online_store/view/screen/customer/compare_result_page.dart';
import 'package:online_store/core/classes/staterequest.dart';

class SelectProductsToComparePage extends StatefulWidget {
  const SelectProductsToComparePage({super.key});

  @override
  State<SelectProductsToComparePage> createState() =>
      _SelectProductsToComparePageState();
}

class _SelectProductsToComparePageState
    extends State<SelectProductsToComparePage> {
  final ProductCustomerController productController = Get.put(
    ProductCustomerController(),
  );
  final CompareController compareController = Get.put(CompareController());

  List<ProductModel> selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "اختر منتجات للمقارنة",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // بطاقة المنتجات المختارة
          if (selectedProducts.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.compare_arrows_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${selectedProducts.length} من 2 منتجات مختارة",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...selectedProducts.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              selectedProducts.remove(product);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

          // قائمة المنتجات
          Expanded(
            child: GetBuilder<ProductCustomerController>(
              builder: (controller) {
                if (controller.isLoading)
                  return const Center(child: CircularProgressIndicator());
                if (controller.products.isEmpty)
                  return Center(child: Text("لا توجد منتجات"));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    final isSelected = selectedProducts.contains(product);

                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        "${(product.priceCents / 100).toStringAsFixed(0)} ل.س",
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: selectedProducts.length >= 2 && !isSelected
                            ? null
                            : (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedProducts.add(product);
                                  } else {
                                    selectedProducts.remove(product);
                                  }
                                });
                              },
                      ),
                      onTap: () {
                        if (selectedProducts.length >= 2 && !isSelected) {
                          Get.snackbar(
                            "تنبيه",
                            "يمكنك اختيار منتجين فقط للمقارنة",
                          );
                          return;
                        }
                        setState(() {
                          if (isSelected)
                            selectedProducts.remove(product);
                          else
                            selectedProducts.add(product);
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedProducts.length == 2
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final productIds = selectedProducts.map((p) => p.id).toList();
                  final result = await compareController.compareProducts(
                    productIds,
                  );

                  if (result == Staterequest.success) {
                    Get.to(() => CompareResultPage());
                  } else {
                    Get.snackbar("خطأ", "فشلت عملية المقارنة");
                  }
                },
                child: const Text("قارن المنتجات"),
              ),
            )
          : null,
    );
  }
}
