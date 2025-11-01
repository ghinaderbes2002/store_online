import 'package:get/get.dart';
import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  final ApiClient apiClient = ApiClient();

  /// إنشاء تصنيف جديد
  Future<Staterequest> createCategory({
    required String name,
    int? parentId,
    bool isActive = true,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/categories';
      print(
        "POST $url with data: {name: $name, parentId: $parentId, isActive: $isActive}",
      );
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      ApiResponse<dynamic> response = await apiClient.postData(
        url: url,
        data: {'name': name.trim(), 'parentId': parentId, 'isActive': isActive},
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Create Category Response Status: ${response.statusCode}");
      print("Create Category Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("تم", "تم إنشاء التصنيف بنجاح 🎉");
        return Staterequest.success;
      }

      Get.snackbar(
        "فشل",
        "تعذر إنشاء التصنيف. تحقق من البيانات وأعد المحاولة.",
      );
      return Staterequest.failure;
    } catch (error) {
      print("Create Category error: $error");
      Get.snackbar("خطأ", "حدث خطأ غير متوقع. تأكد من الاتصال بالإنترنت.");
      return Staterequest.failure;
    }
  }


/// تعديل تصنيف موجود
 Future<Staterequest> updateCategory({
    required int id,
    String? name,
    bool? isActive,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/categories/$id';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name.trim();
      if (isActive != null) data['isActive'] = isActive;

      final response = await apiClient.patchData(
        url: url,
        data: data,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return Staterequest.success;
      }

      return Staterequest.failure;
    } catch (e) {
      print("Update Category error: $e");
      return Staterequest.failure;
    }
  }

/// حذف تصنيف
  Future<Staterequest> deleteCategory({required int id}) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/categories/$id';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.deleteData(
        url: url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Get.snackbar("تم", "تم حذف التصنيف بنجاح 🗑️");
        return Staterequest.success;
      }

      Get.snackbar("فشل", "تعذر حذف التصنيف. حاول مرة أخرى.");
      return Staterequest.failure;
    } catch (e) {
      print("Delete Category error: $e");
      Get.snackbar("خطأ", "حدث خطأ أثناء الحذف.");
      return Staterequest.failure;
    }
  }


  /// جلب جميع التصنيفات
Future<List<CategoryModel>> fetchCategories() async {
    try {
      final url = '${ServerConfig().serverLink}/owner/categories';
      print("GET $url");

      ApiResponse<dynamic> response = await apiClient.getData(url: url);

      print("Fetch Categories Status: ${response.statusCode}");
      print("Fetch Categories Data: ${response.data}");

      if (response.statusCode == 200 && response.data is Map) {
        final items = response.data['items'] as List;
        return items.map((e) => CategoryModel.fromJson(e)).toList();
      }

      return [];
    } catch (error) {
      print("Fetch Categories error: $error");
      return [];
    }
  }

}
