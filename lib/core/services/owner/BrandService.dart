import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/brand_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandService {
  final ApiClient apiClient = ApiClient();

  // إنشاء Brand جديد
  Future<Staterequest> createBrand({
    required String name,
    bool isActive = true,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/brands';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.postData(
        url: url,
        data: {'name': name.trim(), 'isActive': isActive},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201)
        return Staterequest.success;
      return Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }

  // تعديل Brand
  Future<Staterequest> updateBrand({
    required int id,
    String? name,
    bool? isActive,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/brands/$id';
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

      return response.statusCode == 200
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }

  // حذف Brand
  Future<Staterequest> deleteBrand({required int id}) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/brands/$id';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.deleteData(
        url: url,
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }

/// جلب جميع Brands
  Future<List<BrandModel>> fetchBrands() async {
    try {
      final url = '${ServerConfig().serverLink}/owner/brands';
      print("GET $url");

      ApiResponse<dynamic> response = await apiClient.getData(url: url);

      print("Fetch Brands Status: ${response.statusCode}");
      print("Fetch Brands Data: ${response.data}");

      if (response.statusCode == 200 && response.data is Map) {
        final items = response.data['items'] as List;
        return items.map((e) => BrandModel.fromJson(e)).toList();
      }

      return [];
    } catch (error) {
      print("Fetch Brands error: $error");
      return [];
    }
  }


}
