import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/owner/BrandService.dart';
import 'package:online_store/model/brand_model.dart';

class BrandController extends GetxController {
  final BrandService brandService = BrandService();

  bool isLoading = false;
  List<BrandModel> brands = [];

  // Form
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool isActive = true;

  @override
  void onInit() {
    fetchBrands();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // جلب الشركات عند بدء الصفحة
  void fetchBrands() async {
    isLoading = true;
    update();
    brands = await brandService.fetchBrands();
    isLoading = false;
    update();
  }

  // إضافة ماركة جديدة
  void createBrand() async {
    if (!formState.currentState!.validate()) return;

    final name = nameController.text;

    isLoading = true;
    update();

    final result = await brandService.createBrand(
      name: name,
      isActive: isActive,
    );

    if (result == Staterequest.success) {
      nameController.clear();
      isActive = true;
      fetchBrands();
      Get.snackbar(
        "تم الإضافة ✅",
        "تم إضافة الماركة بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade700,
      );
    } else {
      Get.snackbar(
        "فشل الإضافة ❌",
        "حدث خطأ أثناء إضافة الماركة",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    }

    isLoading = false;
    update();
  }

  // تعديل ماركة
  void updateBrand(BrandModel brand) async {
    String newName = brand.name;
    bool newStatus = brand.isActive;

    await Get.defaultDialog(
      title: "تعديل الماركة",
      content: Column(
        children: [
          TextFormField(
            initialValue: newName,
            decoration: const InputDecoration(labelText: "اسم الماركة"),
            onChanged: (val) => newName = val,
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text("نشط"),
            value: newStatus,
            onChanged: (val) => newStatus = val,
          ),
        ],
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

        final result = await brandService.updateBrand(
          id: brand.id,
          name: newName.trim(),
          isActive: newStatus,
        );

        if (result == Staterequest.success) {
          brand.name = newName.trim();
          brand.isActive = newStatus;
          update();
          Get.snackbar("تم", "تم تحديث الماركة بنجاح 🎉");
        } else {
          Get.snackbar("فشل", "تعذر تحديث الماركة. حاول مرة أخرى.");
        }

        isLoading = false;
        update();
      },
    );
  }

  // حذف ماركة
Future<Staterequest> deleteBrand(BrandModel brand) async {
    isLoading = true;
    update();

    final result = await brandService.deleteBrand(id: brand.id);

    if (result == Staterequest.success) {
      brands.remove(brand);
      update();
    }

    isLoading = false;
    update();
    return result; // ✅ ترجع النتيجة
  }

}
