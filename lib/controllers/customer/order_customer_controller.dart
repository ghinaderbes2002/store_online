import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/customer/order_customer_service.dart';
import 'package:online_store/model/order_model.dart';

class OrderCustomerController extends GetxController {
  final OrderCustomerService orderService = OrderCustomerService();

  bool isLoading = false;
  List<OrderModel> orders = [];
  OrderModel? selectedOrder; // لتخزين تفاصيل طلب معين



  // إرسال طلب مباشر
  Future<Staterequest> placeOrder({
    required List<Map<String, dynamic>> items,
    String paymentMethod = "COD",
  }) async {
    isLoading = true;
    update();

    final result = await orderService.placeOrder(
      items: items,
      paymentMethod: paymentMethod,
    );

    isLoading = false;
    update();

    if (result == Staterequest.success) {
      await fetchOrders(); // بعد الطلب، نحدّث قائمة الطلبات
    }

    return result;
  }

  // جلب الطلبات الخاصة بالمستخدم
  Future<void> fetchOrders() async {
    isLoading = true;
    update();

    orders = await orderService.fetchOrders();

    isLoading = false;
    update();
  }

  Future<void> fetchOrderDetails(int orderId) async {
    isLoading = true;
    update();

    selectedOrder = await orderService.fetchOrderDetails(orderId);

    isLoading = false;
    update();
  }


  
  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }
}
