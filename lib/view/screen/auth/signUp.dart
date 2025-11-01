import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/auth/signup_controller.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/function/validinput.dart';
import 'package:online_store/core/them/app_colors.dart';
import 'package:online_store/view/widget/auth/CustomButton.dart';
import 'package:online_store/view/widget/auth/CustomTextFormFiled.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpControllerImp());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: GetBuilder<SignUpControllerImp>(
            builder: (_) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      // Main Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Form(
                            key: controller.formState,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'إنشاء حساب جديد',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'املأ البيانات للمتابعة',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),

                                // Full Name
                                CustomTextFormField(
                                  controller: controller.username,
                                  label: 'الاسم الكامل',
                                  hintText: 'أدخل الاسم الكامل',
                                  prefixIcon: Icons.person_outline,
                                  validator: (val) =>
                                      validInput(val!, 3, 100, "username"),
                                  isDarkMode: false,
                                ),
                                const SizedBox(height: 20),

                                // Email
                                CustomTextFormField(
                                  controller: controller.email,
                                  label: 'البريد الإلكتروني',
                                  hintText: 'example@mail.com',
                                  prefixIcon: Icons.email_outlined,
                                  validator: (val) =>
                                      validInput(val!, 5, 100, "email"),
                                  isDarkMode: false,
                                ),
                                const SizedBox(height: 20),

                                // Phone
                                CustomTextFormField(
                                  controller: controller.phone,
                                  label: 'رقم الهاتف',
                                  hintText: '09xxxxxxxx',
                                  prefixIcon: Icons.phone_android_outlined,
                                  validator: (val) =>
                                      validInput(val!, 9, 20, "phone"),
                                  isDarkMode: false,
                                ),
                                const SizedBox(height: 20),

                                // Password
                                CustomTextFormField(
                                  controller: controller.password,
                                  label: "كلمة المرور",
                                  hintText: "********",
                                  prefixIcon: Icons.lock_outline,
                                  isPassword: controller.isPasswordHidden,
                                  onPasswordToggle:
                                      controller.togglePasswordVisibility,
                                  isDarkMode: false,
                                ),
                                const SizedBox(height: 25),

                                // Sign Up Button
                                CustomButton(
                                  text: 'إنشاء الحساب',
                                  onPressed: () => controller.signUp(),
                                  isLoading:
                                      controller.staterequest ==
                                      Staterequest.loading,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Login redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "لديك حساب بالفعل؟",
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: controller.goToLogin,
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
