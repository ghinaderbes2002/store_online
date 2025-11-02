import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/owner/CategoryService.dart';
import 'package:online_store/model/category_model.dart';

class CategoryController extends GetxController {
  final CategoryService categoryService = CategoryService();

  bool isLoading = false;
  List<CategoryModel> categories = [];

  // Form
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController parentIdController = TextEditingController();
  bool isActive = true;

  void fetchCategories() async {
    isLoading = true;
    update(); // عرض الـ loading
    categories = await categoryService.fetchCategories();
    isLoading = false;
    update(); // تحديث واجهة المستخدم بعد تحميل البيانات
  }

  void createCategory() async {
    if (!formState.currentState!.validate()) return;

    final name = nameController.text;
    final parentId = int.tryParse(parentIdController.text);

    isLoading = true;
    update();

    final result = await categoryService.createCategory(
      name: name,
      parentId: parentId,
      isActive: isActive,
    );

    if (result == Staterequest.success) {
      nameController.clear();
      parentIdController.clear();
      isActive = true;
      fetchCategories(); // إعادة تحميل التصنيفات
    }

    isLoading = false;
    update();
  }

  void updateCategory(CategoryModel cat) async {
    // القيم الحالية
    String newName = cat.name;
    bool newStatus = cat.isActive;

    await Get.defaultDialog(
      title: "تعديل التصنيف",
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextFormField(
                initialValue: newName,
                decoration: const InputDecoration(labelText: "اسم التصنيف"),
                onChanged: (val) => newName = val,
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text("نشط"),
                value: newStatus,
                onChanged: (val) {
                  setState(() => newStatus = val);
                },
              ),
            ],
          );
        },
      ),
      textConfirm: "تحديث",
      textCancel: "إلغاء",
      onConfirm: () async {
        Get.back();

        if (newName.trim().isEmpty) {
          Get.snackbar("خطأ", "الاسم لا يمكن أن يكون فارغًا");
          return;
        }

        isLoading = true;
        update();

        final result = await categoryService.updateCategory(
          id: cat.id,
          name: newName.trim(),
          isActive: newStatus,
        );

        if (result == Staterequest.success) {
          cat.name = newName.trim();
          cat.isActive = newStatus;
          update();
          Get.snackbar("تم", "تم تحديث التصنيف بنجاح 🎉");
        } else {
          Get.snackbar("فشل", "تعذر تحديث التصنيف. حاول مرة أخرى.");
        }

        isLoading = false;
        update();
      },
    );

  }

  Future<void> deleteCategory(CategoryModel cat) async {
    isLoading = true;
    update();

    final result = await categoryService.deleteCategory(id: cat.id);

    if (result == Staterequest.success) {
      categories.remove(cat);
      update();
    } else {
      Get.snackbar(
        "فشل الحذف ❌",
        "حدث خطأ أثناء حذف التصنيف. حاول مجددًا.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }

    isLoading = false;
    update();
  }

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    parentIdController.dispose();
    super.onClose();
  }
}
