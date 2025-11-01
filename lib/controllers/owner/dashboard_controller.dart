// import 'package:get/get.dart';
// import 'package:online_store/core/classes/staterequest.dart';
// import 'package:online_store/core/services/SharedPreferences.dart';
// import 'package:online_store/core/classes/api_client.dart';
// import 'package:online_store/model/dashboard_summary.dart';

// abstract class DashboardController extends GetxController {
//   fetchSummary();
// }

// class DashboardControllerImp extends DashboardController {
//   Staterequest staterequest = Staterequest.none;
//   MyServices myServices = Get.find();

//   var summary = DashboardSummary(
//     totalProducts: 0,
//     totalOrders: 0,
//     totalCustomers: 0,
//   ).obs;

//   @override
//   void onInit() {
//     fetchSummary();
//     super.onInit();
//   }

//   @override
//   fetchSummary() async {
//     staterequest = Staterequest.loading;
//     update();

//     try {
//       final response = await ApiClient().getData("/admin/dashboard-summary");

//       if (response != null) {
//         summary.value = DashboardSummary.fromJson(response);
//         staterequest = Staterequest.success;
//       } else {
//         staterequest = Staterequest.failure;
//       }
//     } catch (e) {
//       print("Dashboard fetch error: $e");
//       staterequest = Staterequest.failure;
//     }

//     update();
//   }
// }
