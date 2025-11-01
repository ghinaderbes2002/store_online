import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/core/classes/staterequest.dart';
import 'package:online_store/core/services/owner/offer_service.dart';
import 'package:online_store/model/offer_model.dart';

class OfferController extends GetxController {
  final OfferService offerService = OfferService();

  bool isLoading = false;
  List<OfferModel> offers = [];

  // Form
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  String type = 'PERCENT';
  DateTime startsAt = DateTime.now();
  DateTime endsAt = DateTime.now().add(Duration(days: 1));
  bool isActive = true;
  List<int> productIds = [];
  List<int> categoryIds = [];

  @override
  void onInit() {
    fetchOffers();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    valueController.dispose();
    super.onClose();
  }

  void fetchOffers() async {
    isLoading = true;
    update();
    offers = await offerService.fetchOffers();
    isLoading = false;
    update();
  }

  void createOffer() async {
    if (!formState.currentState!.validate()) return;

    isLoading = true;
    update();

    final result = await offerService.createOffer(
      name: nameController.text.trim(),
      type: type,
      value: valueController.text.trim(),
      startsAt: startsAt,
      endsAt: endsAt,
      isActive: isActive,
      productIds: productIds,
      categoryIds: categoryIds,
    );

    if (result == Staterequest.success) {
      nameController.clear();
      valueController.clear();
      isActive = true;
      productIds.clear();
      categoryIds.clear();
      fetchOffers();
      Get.snackbar("تم", "تم إنشاء العرض بنجاح");
    } else {
      Get.snackbar("خطأ", "تعذر إنشاء العرض");
    }

    isLoading = false;
    update();
  }

  Future<void> deleteOffer(OfferModel offer) async {
    isLoading = true;
    update();

    final result = await offerService.deleteOffer(offer.id);
    if (result == Staterequest.success) {
      offers.remove(offer);
      update();
      Get.snackbar("تم", "تم حذف العرض بنجاح");
    } else {
      Get.snackbar("خطأ", "تعذر حذف العرض");
    }

    isLoading = false;
    update();
  }


  // تحديث عرض موجود
 void updateOffer(OfferModel offer) async {
    try {
      isLoading = true;
      update();

      final result = await offerService.updateOffer(
        id: offer.id,
        name: offer.name.trim(),
        value: offer.value.trim(),
        isActive: offer.isActive,
      );

      if (result == Staterequest.success) {
        // ✅ تحديث العنصر في القائمة
        final index = offers.indexWhere((o) => o.id == offer.id);
        if (index != -1) {
          offers[index] = offer;
        }

        update();
        Get.snackbar(
          "تم ✅",
          "تم تحديث العرض بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade700,
        );
      } else {
        Get.snackbar(
          "خطأ ❌",
          "تعذر تحديث العرض",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade700,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ أثناء تحديث العرض: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade700,
      );
    } finally {
      isLoading = false;
      update();
    }
  }



}

