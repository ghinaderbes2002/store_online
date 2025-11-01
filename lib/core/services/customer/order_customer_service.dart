import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCustomerService {
  final ApiClient apiClient = ApiClient();

  // إرسال طلب مباشر
  Future<Staterequest> placeOrder({
    required List<Map<String, dynamic>> items,
    String paymentMethod = "COD",
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/orders';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.postData(
        url: url,
        data: {"items": items, "paymentMethod": paymentMethod},
        headers: {"Authorization": "Bearer $token"},
      );

      print("Place Order Response: ${response.statusCode} - ${response.data}");

      return (response.statusCode == 200 || response.statusCode == 201)
          ? Staterequest.success
          : Staterequest.failure;
    } catch (error) {
      print("Place Order error: $error");
      return Staterequest.failure;
    }
  }

  // جلب الطلبات الخاصة بالمستخدم
Future<List<OrderModel>> fetchOrders() async {
    try {
      final url = '${ServerConfig().serverLink}/orders/me';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.getData(
        url: url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 && response.data is Map) {
        final ordersData = response.data['items'] ?? [];
        return (ordersData as List).map((e) {
          return OrderModel(
            id: int.parse(e['id'].toString()),
            customerId: null,
            subtotalCents: e['totalCents'] ?? 0,
            discountCents: 0,
            totalCents: e['totalCents'] ?? 0,
            paymentMethod: "COD", // لأن الـ API لا يعطيها هنا
            status: OrderStatus.values.firstWhere(
              (s) => s.name == e['status'],
              orElse: () => OrderStatus.PLACED,
            ),
            createdAt:
                DateTime.tryParse(e['createdAt'] ?? '') ?? DateTime.now(),
            customer: null,
            items: [], // بدون منتجات هنا
          );
        }).toList();
      }

      return [];
    } catch (e) {
      print("Fetch Orders error: $e");
      return [];
    }
  }

Future<OrderModel?> fetchOrderDetails(int orderId) async {
    try {
      final url = '${ServerConfig().serverLink}/orders/me/$orderId';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.getData(
        url: url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['order'] != null) {
        return OrderModel.fromJson(
          response.data['order'],
        ); // تحتوي على المنتجات
      }

      return null;
    } catch (e) {
      print("Fetch Order Details error: $e");
      return null;
    }
  }


}
