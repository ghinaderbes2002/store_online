import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/compare_service.dart';
import 'package:online_store/model/product_model.dart';

class CompareController extends GetxController {
  final CompareService compareService = CompareService();

  bool isLoading = false;
  List<ProductModel> products = [];
  List<Map<String, dynamic>> matrix = [];

  Future<Staterequest> compareProducts(List<int> productIds) async {
    isLoading = true;
    update();

    final result = await compareService.compareProducts(productIds);

    if (result['state'] == Staterequest.success) {
      products = result['products'];
      matrix = result['matrix'];
    }

    isLoading = false;
    update();

    return result['state'];
  }
}
