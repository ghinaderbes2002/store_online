import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OrderService {
  final ApiClient apiClient = ApiClient();

  Future<List<OrderModel>> fetchOrders({
    String status = '',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url =
          '${ServerConfig().serverLink}/owner/orders?status=$status&page=$page&limit=$limit';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.getData(
        url: url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.data is Map) {
        final items = response.data['items'] as List;
        return items.map((e) => OrderModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("Fetch Orders error: $e");
      return [];
    }
  }

  Future<Staterequest> updateOrderStatus({
    required int id,
    required String status,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/orders/$id/status';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.patchData(
        url: url,
        data: {'status': status},
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }
}
