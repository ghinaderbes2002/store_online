import 'package:get/get.dart';
import 'package:online_store/core/services/SharedPreferences.dart';

class ServerConfig {
  static final ServerConfig _instance = ServerConfig._internal();
  factory ServerConfig() => _instance;
  ServerConfig._internal();

  static const String _key = "server_link";
  String _serverLink = "http://192.168.0.8:3000";
  String get serverLink => _serverLink;

  Future<void> loadServerLink() async {
    final myServices = Get.find<MyServices>();
    final savedLink = myServices.sharedPref.getString(_key);
    if (savedLink != null && savedLink.isNotEmpty) {
      _serverLink = savedLink;
    }
  }
}
