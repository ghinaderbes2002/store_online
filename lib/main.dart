import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/core/constant/App_routes.dart';
import 'package:online_store/core/services/SharedPreferences.dart';
import 'package:online_store/routes.dart';
import 'package:online_store/controllers/auth/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();

  final myServices = await Get.putAsync(() => MyServices().init());

  // 🔹 إذا المستخدم مسجل دخول من قبل
  bool isLoggedIn = myServices.sharedPref.getBool("isLoggedIn") ?? false;
  String role = myServices.sharedPref.getString("role") ?? "";

  // 🔹 تسجيل الكنترولر بشكل دائم حتى بعد الخروج والدخول
  Get.put(LoginControllerImp(), permanent: true);

  runApp(MyApp(isLoggedIn: isLoggedIn, role: role));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;

  const MyApp({super.key, required this.isLoggedIn, required this.role});

  @override
  Widget build(BuildContext context) {
    // 🔹 تحديد الصفحة الأولى حسب حالة الدخول
    String initialRoute;
    if (isLoggedIn) {
      if (role == "OWNER") {
        initialRoute = AppRoute.dashboard;
      } else {
        initialRoute = AppRoute.homeMain;
      }
    } else {
      initialRoute = AppRoute.login;
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: routes,
    );
  }
}
