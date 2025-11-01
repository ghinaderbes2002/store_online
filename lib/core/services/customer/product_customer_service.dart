import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/model/product_model.dart';
import 'package:online_store/core/constant/App_link.dart';

class ProductCustomerService {
  final ApiClient apiClient = ApiClient();

  Future<List<ProductModel>> fetchProductsByCategory({
    required int categoryId,
    String search = '',
    int? brandId,
    int page = 1,
    int limit = 20,
    String sort = '-id',
  }) async {
    try {
      final url =
          '${ServerConfig().serverLink}/catalog/products?search=$search&categoryId=$categoryId&brandId=${brandId ?? ''}&page=$page&limit=$limit&sort=$sort';

      print('GET $url');

      final response = await apiClient.getData(url: url);

      print("Fetch Products Status: ${response.statusCode}");
      print("Fetch Products Data: ${response.data}");

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['items'] is List) {
        final items = response.data['items'] as List;
        return items.map((e) => ProductModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print('Fetch Products Error: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchBrands() async {
    try {
      final url = '${ServerConfig().serverLink}/catalog/brands';
      print('GET $url');

      final response = await apiClient.getData(url: url);

      print("Fetch Brands Status: ${response.statusCode}");
      print("Fetch Brands Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // إذا كانت النتيجة عبارة عن قائمة
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }

        // إذا كانت موجودة ضمن حقل "items"
        if (data is Map && data['items'] is List) {
          return List<Map<String, dynamic>>.from(data['items']);
        }
      }

      return [];
    } catch (e) {
      print('Fetch Brands Error: $e');
      return [];
    }
  }


Future<ProductModel?> fetchProductDetails(int productId) async {
    try {
      final url = '${ServerConfig().serverLink}/catalog/products/$productId';
      print('GET $url');

      final response = await apiClient.getData(url: url);

      print("Fetch Product Details Status: ${response.statusCode}");
      print("Fetch Product Details Data: ${response.data}");

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['product'] != null) {
        return ProductModel.fromJson(
          Map<String, dynamic>.from(response.data['product']),
        );
      }

      return null;
    } catch (e) {
      print('Fetch Product Details Error: $e');
      return null;
    }
  }

}
