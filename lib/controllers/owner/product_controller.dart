import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/owner/product_service.dart';
import 'package:online_store/model/product_model.dart';

class ProductController extends GetxController {
  final ProductService productService = ProductService();

  bool isLoading = false;
  List<ProductModel> products = [];

  // Form
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController ramController = TextEditingController();
  TextEditingController storageController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController displayController = TextEditingController();
  TextEditingController batteryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  File? pickedImage;



  bool isActive = true;
  int? categoryId;
  int? brandId;




  // جلب المنتجات عند بدء الصفحة
  void fetchProducts() async {
    isLoading = true;
    update();
    products = await productService.fetchProducts();
    isLoading = false;
    update();
  }

Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      update(); // لتحديث الـ UI
    } else {
      print("No image selected.");
    }
  }


Future<void> saveUpdatedProduct(ProductModel product) async {
    try {
      isLoading = true;
      update();

      final result = await productService.updateProduct(
        id: product.id,
        name: nameController.text,
        sku: skuController.text,
        priceCents: int.tryParse(priceController.text) ?? 0,
        stockQty: int.tryParse(stockController.text) ?? 0,
        isActive: isActive,
        categoryId: categoryId,
        brandId: brandId,
        description: descriptionController.text,
        features: {
          'ram': ramController.text,
          'storage': storageController.text,
          'color': colorController.text,
          'display': displayController.text,
          'battery': batteryController.text,
        },
        imageFile: pickedImage, // الصورة من الموبايل
      );

      if (result == Staterequest.success) {
        Get.snackbar("تم", "تم تحديث المنتج بنجاح 🎉");
        fetchProducts();
      } else {
        Get.snackbar("خطأ", "فشل تحديث المنتج");
      }
    } catch (e) {
      print("❌ Error updating product: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء التحديث");
    } finally {
      isLoading = false;
      update();
    }
  }



  void createProduct() async {
    if (!formState.currentState!.validate()) return;

    isLoading = true;
    update();

    final result = await productService.createProduct(
      name: nameController.text,
      sku: skuController.text,
      priceCents: int.tryParse(priceController.text) ?? 0,
      stockQty: int.tryParse(stockController.text) ?? 0,
      isActive: isActive,
      categoryId: categoryId,
      brandId: brandId,
      features: {
        'ram': ramController.text,
        'storage': storageController.text,
        'color': colorController.text,
        'display': displayController.text,
        'battery': batteryController.text,
      },
      description: descriptionController.text,
      imageFile: pickedImage, // هنا نرسل الملف
    );

    if (result == Staterequest.success) {
      // مسح البيانات بعد الحفظ
      nameController.clear();
      skuController.clear();
      priceController.clear();
      stockController.clear();
      ramController.clear();
      storageController.clear();
      colorController.clear();
      displayController.clear();
      batteryController.clear();
      descriptionController.clear();
      pickedImage = null; // إعادة الصورة للصفر
      isActive = true;

      fetchProducts(); // تحديث القائمة
    }

    isLoading = false;
    update();
  }


  void updateProduct(ProductModel product) async {
    String newName = product.name;
    int newPrice = product.priceCents;
    int newStock = product.stockQty;
    bool newStatus = product.isActive;

    await Get.defaultDialog(
      title: "تعديل المنتج",
      content: Column(
        children: [
          TextFormField(
            initialValue: newName,
            decoration: const InputDecoration(labelText: "اسم المنتج"),
            onChanged: (val) => newName = val,
          ),
          TextFormField(
            initialValue: newPrice.toString(),
            decoration: const InputDecoration(labelText: "السعر"),
            keyboardType: TextInputType.number,
            onChanged: (val) => newPrice = int.tryParse(val) ?? newPrice,
          ),
          TextFormField(
            initialValue: newStock.toString(),
            decoration: const InputDecoration(labelText: "الكمية"),
            keyboardType: TextInputType.number,
            onChanged: (val) => newStock = int.tryParse(val) ?? newStock,
          ),
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
        isLoading = true;
        update();

        final result = await productService.updateProduct(
          id: product.id,
          name: newName,
          priceCents: newPrice,
          stockQty: newStock,
          isActive: newStatus,
        );

        if (result == Staterequest.success) {
          product.name = newName;
          product.priceCents = newPrice;
          product.stockQty = newStock;
          product.isActive = newStatus;
          update();
          Get.snackbar("تم", "تم تحديث المنتج بنجاح 🎉");
        } else {
          Get.snackbar("فشل", "تعذر تحديث المنتج. حاول مرة أخرى.");
        }

        isLoading = false;
        update();
      },
    );
  }

  void deleteProduct(ProductModel product) async {
    bool confirmed = false;

    await Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل تريد حذف المنتج ${product.name}؟",
      textConfirm: "حذف",
      textCancel: "إلغاء",
      onConfirm: () {
        confirmed = true;
        Get.back();
      },
    );

    if (!confirmed) return;

    isLoading = true;
    update();

    final result = await productService.deleteProduct(product.id);

    if (result == Staterequest.success) {
      products.remove(product);
      update();
    }

    isLoading = false;
    update();
  }

  @override
  void onInit() {
    fetchProducts();

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    skuController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }
}
