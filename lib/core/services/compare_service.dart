import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompareService {
  final ApiClient apiClient = ApiClient();

  Future<Map<String, dynamic>> compareProducts(List<int> productIds) async {
    try {
      final url = '${ServerConfig().serverLink}/catalog/compare';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.postData(
        url: url,
        data: {"productIds": productIds.map((e) => e.toString()).toList()},
        headers: {"Authorization": "Bearer $token"},
      );

      print("Compare Response Status: ${response.statusCode}");
      print("Compare Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data;

        final List<ProductModel> products = (data['products'] as List)
            .map((p) => ProductModel.fromJson(p))
            .toList();

        final List<Map<String, dynamic>> matrix = (data['matrix'] as List)
            .map((m) => Map<String, dynamic>.from(m))
            .toList();

        return {
          'state': Staterequest.success,
          'products': products,
          'matrix': matrix,
        };
      }

      return {'state': Staterequest.failure};
    } catch (error) {
      print("Compare error: $error");
      return {'state': Staterequest.failure};
    }
  }
}
