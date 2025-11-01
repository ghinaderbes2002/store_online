import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/owner/OrderService.dart';
import 'package:online_store/model/order_model.dart';

class OrderController extends GetxController {
  final OrderService orderService = OrderService();

  bool isLoading = false;
  List<OrderModel> orders = [];

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  // جلب الطلبات
  void fetchOrders({String status = '', int page = 1, int limit = 20}) async {
    isLoading = true;
    update();

    orders = await orderService.fetchOrders(
      status: status,
      page: page,
      limit: limit,
    );

    isLoading = false;
    update();
  }

  // تحديث حالة الطلب
  void updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    isLoading = true;
    update();

    final result = await orderService.updateOrderStatus(
      id: order.id,
      status: newStatus.name, // نرسل الاسم كسلسلة للـ API
    );

    if (result == Staterequest.success) {
      order.status = newStatus; // ✅ نحدث الـ enum مباشرة
      Get.snackbar("تم", "تم تحديث حالة الطلب بنجاح");
    } else {
      Get.snackbar("خطأ", "تعذر تحديث حالة الطلب");
    }

    isLoading = false;
    update();
  }
}
