import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_routes.dart';
import 'package:online_store/core/services/SharedPreferences.dart';
import 'package:online_store/core/services/auth/auth_service.dart';

abstract class SignUpController extends GetxController {
  signUp();
  goToLogin();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;

  Staterequest staterequest = Staterequest.none;
  bool isPasswordHidden = true;

  final AuthService authService = AuthService();
  MyServices myServices = Get.find();

  @override
  void onInit() {
    username = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  @override
  signUp() async {
    if (formState.currentState!.validate()) {
      staterequest = Staterequest.loading;
      update();

      staterequest = await authService.registerUser(
        name: username.text.trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
        password: password.text.trim(),
      );

      update();

      if (staterequest == Staterequest.success) {
        await myServices.sharedPref.setBool("isLoggedIn", true);
        Get.offAllNamed(AppRoute.login);
      } else {
        Get.snackbar("فشل", "حدث خطأ أثناء إنشاء الحساب. حاول مجددًا.");
      }
    }
  }

  @override
  goToLogin() {
    Get.offAllNamed(AppRoute.login);
  }
}
