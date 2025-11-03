import 'dart:io';
import 'package:dio/dio.dart';
import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final ApiClient apiClient = ApiClient();

  Future<Staterequest> createProduct({
    required String name,
    required String sku,
    int priceCents = 0,
    int stockQty = 0,
    bool isActive = true,
    int? categoryId,
    int? brandId,
    Map<String, dynamic>? features,
    String? description,
    File? imageFile, // بدل imageUrl
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final dio = Dio();

      // تجهيز الـ FormData للـ multipart
      final formData = FormData.fromMap({
        'name': name,
        'sku': sku,
        'priceCents': priceCents,
        'stockQty': stockQty,
        'isActive': isActive,
        'categoryId': categoryId,
        'brandId': brandId,
        'features': features != null ? features : null,
        'description': description,
      if (imageFile != null)
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),

      });

      final response = await dio.post(
        '${ServerConfig().serverLink}/owner/products',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Staterequest.success;
      }
      return Staterequest.failure;
    } catch (e) {
      print("❌ Dio createProduct error: $e");
      return Staterequest.failure;
    }
  }

Future<Staterequest> updateProduct({
    required int id,
    String? name,
    String? sku,
    int? priceCents,
    int? stockQty,
    bool? isActive,
    int? categoryId,
    int? brandId,
    String? description,
    Map<String, dynamic>? features,
    File? imageFile, // لو الصورة من الموبايل
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/products/$id';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final dio = Dio();

      final formData = FormData();

      if (name != null) formData.fields.add(MapEntry('name', name));
      if (sku != null) formData.fields.add(MapEntry('sku', sku));
      if (priceCents != null)
        formData.fields.add(MapEntry('priceCents', priceCents.toString()));
      if (stockQty != null)
        formData.fields.add(MapEntry('stockQty', stockQty.toString()));
      if (isActive != null)
        formData.fields.add(MapEntry('isActive', isActive.toString()));
      if (categoryId != null)
        formData.fields.add(MapEntry('categoryId', categoryId.toString()));
      if (brandId != null)
        formData.fields.add(MapEntry('brandId', brandId.toString()));
      if (description != null)
        formData.fields.add(MapEntry('description', description));
      if (features != null)
        formData.fields.add(MapEntry('features', features.toString()));

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      final response = await dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.statusCode == 200
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      print("❌ Dio updateProduct error: $e");
      return Staterequest.failure;
    }
  }


  Future<Staterequest> deleteProduct(int id) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/products/$id';
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

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final url = '${ServerConfig().serverLink}/owner/products';
      final response = await apiClient.getData(url: url);

      if (response.statusCode == 200 && response.data is Map) {
        final items = response.data['items'] as List;
        return items.map((e) => ProductModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
