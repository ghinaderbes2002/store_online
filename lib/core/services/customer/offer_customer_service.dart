import 'package:online_store/core/classes/api_client.dart';
import 'package:online_store/model/offer_model.dart';
import 'package:online_store/core/constant/App_link.dart';

class OfferCustomerService {
  final ApiClient apiClient = ApiClient();

  /// جلب العروض الحالية فقط
  Future<List<OfferModel>> fetchOffers() async {
    try {
      final url = '${ServerConfig().serverLink}/catalog/offers?now=true';
      final response = await apiClient.getData(url: url);

      if (response.statusCode == 200 && response.data is Map) {
        final offersData = response.data['items'] ?? [];

        return (offersData as List).map((e) => OfferModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("❌ Fetch Offers error: $e");
      return [];
    }
  }
}
