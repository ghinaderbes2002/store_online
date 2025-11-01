import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_routes.dart';
import 'package:online_store/core/services/SharedPreferences.dart';
import 'package:online_store/core/services/auth/auth_service.dart';

abstract class LoginController extends GetxController {
  login();
  logout();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController phone;

  Staterequest staterequest = Staterequest.none;
  bool isPasswordHidden = true;

  final AuthService authService = AuthService();
  MyServices myServices = Get.find();

  // 🔹 خريطة لتخزين معلومات المستخدم
  Map<String, dynamic> user = {};

  @override
  void onInit() {
    username = TextEditingController();
    password = TextEditingController();
    phone = TextEditingController();

    loadUserData();
    super.onInit();
  }

  void loadUserData() {
    user = {
      "username": myServices.sharedPref.getString("username") ?? "",
      "email": myServices.sharedPref.getString("email") ?? "",
      "phone": myServices.sharedPref.getString("phone") ?? "",
      "role": myServices.sharedPref.getString("role") ?? "",
    };
    update();
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  @override
  login() async {
    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();

      final result = await authService.loginUser(
        username: username.text.trim(),
        phone: phone.text.trim(),
        password: password.text.trim(),
      );

      if (result is Map && result["message"] == "Login successful") {
        final role = result["role"];
        final accessToken = result["accessToken"];
        final userData = result["user"];

        // ✅ حفظ بيانات المستخدم
        await myServices.sharedPref.setBool("isLoggedIn", true);
        await myServices.sharedPref.setString("role", role);
        await myServices.sharedPref.setString("token", accessToken);

      await myServices.sharedPref.setString(
          "username",
          userData["name"] ?? "",
        );
        await myServices.sharedPref.setString("email", userData["email"] ?? "");
        await myServices.sharedPref.setString("phone", userData["phone"] ?? "");


        // تحديث المتغير المحلي
        loadUserData();

        // ✅ الانتقال حسب الدور
        if (role == "OWNER") {
          Get.offAllNamed(AppRoute.dashboard);
        } else if (role == "CUSTOMER") {
          Get.offAllNamed(AppRoute.homeMain);
        }

        staterequest = Staterequest.success;
      } else {
        staterequest = Staterequest.failure;
        Get.snackbar("فشل", "اسم المستخدم أو كلمة المرور غير صحيحة");
      }

      update();
    }
  }

  @override
  void logout() async {
    await myServices.sharedPref.clear();
    user = {};
    update();

    Get.offAllNamed(AppRoute.login);

    Get.snackbar(
      "تم تسجيل الخروج",
      "تم تسجيل خروجك بنجاح",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
