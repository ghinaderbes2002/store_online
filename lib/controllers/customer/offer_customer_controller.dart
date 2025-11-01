import 'package:get/get.dart';
import 'package:online_store/model/offer_model.dart';
import 'package:online_store/core/services/customer/offer_customer_service.dart';

class OfferCustomerController extends GetxController {
  final OfferCustomerService offerService = OfferCustomerService();

  bool isLoading = false;
  List<OfferModel> offers = [];

  Future<void> fetchOffers() async {
    isLoading = true;
    update();

    offers = await offerService.fetchOffers();

    isLoading = false;
    update();
  }

  @override
  void onInit() {
    fetchOffers();
    super.onInit();
  }
}
