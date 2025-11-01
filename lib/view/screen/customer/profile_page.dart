import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/auth/login_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginControllerImp>(
      builder: (controller) {
        final user = controller.user;

        final username = user["username"]?.isNotEmpty == true
            ? user["username"]
            : "غير معروف";
        final phone = user["phone"]?.isNotEmpty == true
            ? user["phone"]
            : "لا يوجد رقم";
        final email = user["email"]?.isNotEmpty == true
            ? user["email"]
            : "لا يوجد بريد";

        return Scaffold(
          appBar: AppBar(
            title: const Text("الملف الشخصي"),
            centerTitle: true,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 60),
                ),
                const SizedBox(height: 16),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(phone, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      title: "تأكيد الخروج",
                      middleText: "هل تريد تسجيل الخروج؟",
                      textCancel: "إلغاء",
                      textConfirm: "نعم",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back(); // يغلق الـ Dialog
                        controller.logout();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
