import 'package:get/get.dart';
import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();
 Future<Map<String, dynamic>> loginUser({
    required String username,
    required String phone,
    required String password,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/auth/login';
      print("Full login URL: $url");

      ApiResponse<dynamic> response = await apiClient.postData(
        url: url,
        data: {
          'username': username.trim(),
          'password': password.trim(),
          'phone': phone.trim(),
        },
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          // حفظ التوكنات والبيانات
          final token = responseData["accessToken"] ?? "";
          final refreshToken = responseData["refreshToken"] ?? "";
          final user = responseData["user"] ?? {};

          final prefs = await SharedPreferences.getInstance();
          final userId = int.tryParse(user["id"].toString()) ?? 0;

          await prefs.setString('token', token);
          await prefs.setString('refreshToken', refreshToken);
          await prefs.setInt('user_id', userId);
          await prefs.setString('user_name', user["name"] ?? "");
          await prefs.setString('user_phone', user["phone"] ?? "");
          await prefs.setString('user_role', user["role"] ?? "");

          // ✅ نرجع الرد الأصلي من السيرفر
          return responseData;
        }
      }

      Get.snackbar("فشل", "اسم المستخدم أو كلمة المرور غير صحيحة");
      return {"message": "Login failed"};
    } catch (error) {
      print("Login error: $error");
      Get.snackbar("خطأ", "حدث خطأ غير متوقع، تأكد من الاتصال بالإنترنت.");
      return {"message": "Error"};
    }
  }

Future<Staterequest> registerUser({
    required String name,
    required String phone,
    required String password,
    String? email, // اختياري
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/auth/signup';
      print("Full register URL: $url");

      final data = {
        'name': name.trim(),
        'phone': phone.trim(),
        'password': password.trim(),
      };

      if (email != null && email.isNotEmpty) {
        data['email'] = email.trim();
      }

      print("Register data: $data");

      ApiResponse<dynamic> response = await apiClient.postData(
        url: url,
        data: data,
      );

      print("Register Response Status: ${response.statusCode}");
      print("Register Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final token = responseData["accessToken"] ?? "";
          final refreshToken = responseData["refreshToken"] ?? "";
          final user = responseData["user"] ?? {};

          final prefs = await SharedPreferences.getInstance();
          final userId = int.tryParse(user["id"].toString()) ?? 0;

          await prefs.setString('token', token);
          await prefs.setString('refreshToken', refreshToken);
          await prefs.setInt('user_id', userId);
          await prefs.setString('user_name', user["name"] ?? "");
          await prefs.setString('user_phone', user["phone"] ?? "");
          await prefs.setString('user_role', user["role"] ?? "");

          Get.snackbar("تم", "تم إنشاء الحساب بنجاح 🎉");
          return Staterequest.success;
        }
      }

      Get.snackbar("فشل", "تعذر إنشاء الحساب. تحقق من البيانات وأعد المحاولة.");
      return Staterequest.failure;
    } catch (error) {
      print("Register error: $error");
      Get.snackbar("خطأ", "حدث خطأ غير متوقع. تأكد من الاتصال بالإنترنت.");
      return Staterequest.failure;
    }
  }
}
