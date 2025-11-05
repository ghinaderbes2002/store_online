// import 'package:get/get.dart';
// import 'package:online_store/core/services/SharedPreferences.dart';

// class ServerConfig {
//   static final ServerConfig _instance = ServerConfig._internal();
//   factory ServerConfig() => _instance;
//   ServerConfig._internal();

//   static const String _key = "server_link";
//   String _serverLink = "http://192.168.0.8:3000";
//   String get serverLink => _serverLink;

//   Future<void> loadServerLink() async {
//     final myServices = Get.find<MyServices>();
//     final savedLink = myServices.sharedPref.getString(_key);
//     if (savedLink != null && savedLink.isNotEmpty) {
//       _serverLink = savedLink;
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:online_store/core/services/SharedPreferences.dart';

class ServerConfig {
  static final ServerConfig _instance = ServerConfig._internal();
  factory ServerConfig() => _instance;
  ServerConfig._internal();

  static const String _key = "server_ip";

  String _serverIP = "192.168.0.8"; // الافتراضي

  // 👇 هون الرابط ثابت مع بورت 3000 والفريق يستخدم /auth, /owner ...
  String get serverLink => "http://$_serverIP:3000";

  Future<void> loadServerLink() async {
    final myServices = Get.find<MyServices>();
    final savedIP = myServices.sharedPref.getString(_key);
    if (savedIP != null && savedIP.isNotEmpty) {
      _serverIP = savedIP;
    }
  }

  Future<void> updateServerLink(String newIP) async {
    _serverIP = newIP;
    final myServices = Get.find<MyServices>();
    await myServices.sharedPref.setString(_key, newIP);
  }

  Future<void> resetToDefault() async {
    _serverIP = "192.168.0.8";
    final myServices = Get.find<MyServices>();
    await myServices.sharedPref.setString(_key, _serverIP);
  }
}
