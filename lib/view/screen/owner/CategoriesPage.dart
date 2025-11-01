import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/owner/category_controller.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});
  final controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // قسم الإضافة في الأعلى
              Container(
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
                            "إضافة تصنيف جديد",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: "اسم التصنيف",
                          hintText: "أدخل اسم التصنيف",
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? "الحقل مطلوب" : null,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SwitchListTile(
                          value: controller.isActive,
                          title: const Text(
                            "حالة التصنيف",
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
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: controller.createCategory,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text(
                            "إضافة التصنيف",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
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
              // قسم القائمة
              Expanded(
                child: controller.categories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "لا توجد تصنيفات",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "قم بإضافة تصنيف جديد من الأعلى",
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
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final cat = controller.categories[index];
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
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: cat.isActive
                                      ? Colors.green.shade50
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: cat.isActive
                                      ? Colors.green.shade700
                                      : Colors.grey.shade600,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                cat.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cat.isActive
                                          ? Colors.green.shade50
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          cat.isActive
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          size: 14,
                                          color: cat.isActive
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          cat.isActive ? "نشط" : "غير نشط",
                                          style: TextStyle(
                                            color: cat.isActive
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
                                        controller.updateCategory(cat);
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
                                        _showDeleteDialog(
                                          context,
                                          controller,
                                          cat,
                                        );
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
  
void _showDeleteDialog(
    BuildContext context,
    CategoryController controller,
    dynamic cat,
  ) {
    showDialog(
      context: Get.context ?? context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text("تأكيد الحذف"),
            ],
          ),
          content: Text("هل أنت متأكد من حذف التصنيف '${cat.name}'؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // أغلق الـ Dialog أولاً

                await controller.deleteCategory(cat); // نفّذ الحذف فعلياً

                Get.snackbar(
                  "تم الحذف ✅",
                  "تم حذف التصنيف بنجاح",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade50,
                  colorText: Colors.green.shade700,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("حذف"),
            ),
          ],
        );
      },
    );
  }


  }

