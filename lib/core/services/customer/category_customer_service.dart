import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/category_model.dart';

class CategoryCustomerService {
  final ApiClient apiClient = ApiClient();

  // جلب جميع التصنيفات
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final url = '${ServerConfig().serverLink}/catalog/categories';
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

  // إنشاء تصنيف جديد (لو لاحقًا بدك تضيف من التطبيق)
//   Future<Staterequest> createCategory({
//     required String name,
//     bool isActive = true,
//     int? parentId,
//   }) async {
//     try {
//       final url = '${ServerConfig().serverLink}/owner/categories';
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';

//       final response = await apiClient.postData(
//         url: url,
//         data: {'name': name.trim(), 'isActive': isActive, 'parentId': parentId},
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       return (response.statusCode == 200 || response.statusCode == 201)
//           ? Staterequest.success
//           : Staterequest.failure;
//     } catch (e) {
//       return Staterequest.failure;
//     }
//   }
}
