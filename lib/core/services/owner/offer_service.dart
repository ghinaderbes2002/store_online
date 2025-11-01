import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/constant/App_link.dart';
import 'package:online_store/model/offer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferService {
  final ApiClient apiClient = ApiClient();

  Future<List<OfferModel>> fetchOffers() async {
    try {
      final url = '${ServerConfig().serverLink}/owner/offers';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.getData(
        url: url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.data is Map) {
        final items = response.data['items'] as List;
        return items.map((e) => OfferModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Fetch Offers error: $e");
      return [];
    }
  }

  Future<Staterequest> createOffer({
    required String name,
    required String type,
    required String value,
    required DateTime startsAt,
    required DateTime endsAt,
    bool isActive = true,
    List<int> productIds = const [],
    List<int> categoryIds = const [],
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/offers';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.postData(
        url: url,
        data: {
          'name': name,
          'type': type,
          'value': value,
          'startsAt': startsAt.toIso8601String(),
          'endsAt': endsAt.toIso8601String(),
          'isActive': isActive,
          'productIds': productIds,
          'categoryIds': categoryIds,
        },
        headers: {'Authorization': 'Bearer $token'},
      );

      return (response.statusCode == 200 || response.statusCode == 201)
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }

  Future<Staterequest> deleteOffer(int id) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/offers/$id';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await apiClient.deleteData(
        url: url,
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }

// تعديل عرض موجود
  Future<Staterequest> updateOffer({
    required int id,
    String? name,
    String? type,
    String? value,
    DateTime? startsAt,
    DateTime? endsAt,
    bool? isActive,
    List<int>? productIds,
    List<int>? categoryIds,
  }) async {
    try {
      final url = '${ServerConfig().serverLink}/owner/offers/$id';
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (type != null) data['type'] = type;
      if (value != null) data['value'] = value;
      if (startsAt != null) data['startsAt'] = startsAt.toIso8601String();
      if (endsAt != null) data['endsAt'] = endsAt.toIso8601String();
      if (isActive != null) data['isActive'] = isActive;
      if (productIds != null) data['productIds'] = productIds;
      if (categoryIds != null) data['categoryIds'] = categoryIds;

      final response = await apiClient.patchData(
        url: url,
        data: data,
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200
          ? Staterequest.success
          : Staterequest.failure;
    } catch (e) {
      return Staterequest.failure;
    }
  }



}
