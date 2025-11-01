import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/compare_controller.dart';

class CompareResultPage extends StatelessWidget {
  CompareResultPage({super.key});

  final CompareController controller = Get.find<CompareController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نتيجة المقارنة"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<CompareController>(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.products.isEmpty || controller.matrix.isEmpty) {
            return const Center(child: Text("لا توجد بيانات للمقارنة"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // بطاقة المنتجات
                Row(
                  children: controller.products.map((product) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade600,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // جدول الميزات
                Column(
                  children: controller.matrix.map((row) {
                  final String feature = (row['key']?.toString() ?? '-');
                    final List<dynamic> values = row['values'] ?? [];

                    final String value1 = values.isNotEmpty
                        ? (values[0]?.toString() ?? '-')
                        : '-';
                    final String value2 = values.length > 1
                        ? (values[1]?.toString() ?? '-')
                        : '-';


                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    value1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    value2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
