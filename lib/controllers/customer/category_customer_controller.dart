import 'package:get/get.dart';
import 'package:online_store/core/services/customer/category_customer_service.dart';
import 'package:online_store/model/category_model.dart';

class CategoryCustomerController extends GetxController {
  final CategoryCustomerService categoryService = CategoryCustomerService();

  bool isLoading = false;
  List<CategoryModel> categories = [];

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // جلب التصنيفات
  void fetchCategories() async {
    isLoading = true;
    update();

    categories = await categoryService.fetchCategories();

    isLoading = false;
    update();
  }

  // إضافة تصنيف جديد
  // Future<void> createCategory(String name, {bool isActive = true}) async {
  //   isLoading = true;
  //   update();

  //   final result = await categoryService.createCategory(
  //     name: name,
  //     isActive: isActive,
  //   );
  //   if (result == Staterequest.success) {
  //     Get.snackbar("تم", "تم إضافة التصنيف بنجاح 🎉");
  //     fetchCategories();
  //   } else {
  //     Get.snackbar("فشل", "تعذر إضافة التصنيف");
  //   }

  //   isLoading = false;
  //   update();
  // }
}
