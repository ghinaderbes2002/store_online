import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/owner/offer_controller.dart';
import 'package:online_store/model/offer_model.dart';

class OffersPage extends StatelessWidget {
  final OfferController controller = Get.put(OfferController());

  OffersPage({super.key});

  final List<String> offerTypes = ["PERCENT", "AMOUNT"]; // ✅ تم التعديل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OfferController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // قسم الإضافة في الأعلى
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.pink.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "إضافة عرض جديد",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // اسم العرض
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: "اسم العرض",
                          hintText: "مثال: خصم الصيف",
                          prefixIcon: const Icon(Icons.local_offer_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.pink,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "الاسم مطلوب"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // القيمة ونوع العرض في صف واحد
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.valueController,
                              decoration: InputDecoration(
                                labelText: "القيمة",
                                hintText: "0",
                                // prefixIcon: const Icon(Icons.percent_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.pink,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? "القيمة مطلوبة"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.type,
                              decoration: InputDecoration(
                                labelText: "نوع العرض",
                                prefixIcon: const Icon(Icons.category_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.pink,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              items: offerTypes
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type == "PERCENT"
                                            ? "نسبة مئوية"
                                            : "مبلغ ثابت",
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  controller.type = val;
                                  controller.update();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Switch للحالة
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SwitchListTile(
                          value: controller.isActive,
                          title: const Text(
                            "حالة العرض",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            controller.isActive ? "نشط" : "غير نشط",
                            style: TextStyle(
                              color: controller.isActive
                                  ? Colors.green
                                  : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          activeColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (val) {
                            controller.isActive = val;
                            controller.update();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // زر الإضافة
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: controller.createOffer,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text(
                            "إضافة العرض",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // قسم القائمة
              Expanded(
                child: controller.offers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "لا يوجد عروض",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "قم بإضافة عرض جديد من الأعلى",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.offers.length,
                        itemBuilder: (context, index) {
                          final OfferModel offer = controller.offers[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header العرض
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.pink.shade50,
                                        Colors.pink.shade100,
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.local_offer_rounded,
                                          color: Colors.pink.shade700,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offer.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              offer.type == "PERCENT"
                                                  ? "خصم ${offer.value}%"
                                                  : "خصم ${offer.value} \$",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.pink.shade700,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: offer.isActive
                                              ? Colors.green
                                              : Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              offer.isActive
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              offer.isActive
                                                  ? "نشط"
                                                  : "غير نشط",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // تفاصيل العرض
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // الفترة الزمنية
                                      _buildInfoRow(
                                        icon: Icons.calendar_today_outlined,
                                        label: "الفترة",
                                        value:
                                            "${offer.startsAt?.toLocal().toString().split(' ')[0]} - ${offer.endsAt?.toLocal().toString().split(' ')[0]}",
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(height: 12),

                                      // المنتجات المستهدفة
                                      if (offer.productTargets.isNotEmpty)
                                        _buildInfoRow(
                                          icon: Icons.shopping_bag_outlined,
                                          label: "منتجات مستهدفة",
                                          value: offer.productTargets.join(
                                            ', ',
                                          ),
                                          color: Colors.orange,
                                        ),
                                      if (offer.productTargets.isNotEmpty)
                                        const SizedBox(height: 12),

                                      // الفئات المستهدفة
                                      if (offer.categoryTargets.isNotEmpty)
                                        _buildInfoRow(
                                          icon: Icons.category_outlined,
                                          label: "فئات مستهدفة",
                                          value: offer.categoryTargets.join(
                                            ', ',
                                          ),
                                          color: Colors.purple,
                                        ),

                                      const SizedBox(height: 16),

                                      // أزرار التحكم
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                _showEditDialog(context, offer);
                                              },
                                              icon: const Icon(
                                                Icons.edit_rounded,
                                                size: 18,
                                              ),
                                              label: const Text("تعديل"),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: Colors.blue,
                                                side: const BorderSide(
                                                  color: Colors.blue,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  controller.deleteOffer(offer),
                                              icon: const Icon(
                                                Icons.delete_rounded,
                                                size: 18,
                                              ),
                                              label: const Text("حذف"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, OfferModel offer) {
    final nameController = TextEditingController(text: offer.name);
    final valueController = TextEditingController(text: offer.value.toString());
    String selectedType = offer.type;
    bool isActive = offer.isActive;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_rounded, color: Colors.blue),
              SizedBox(width: 8),
              Text("تعديل العرض"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "اسم العرض",
                    prefixIcon: const Icon(Icons.local_offer_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: "القيمة",
                    // prefixIcon: const Icon(Icons.percent_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: "نوع العرض",
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ["PERCENT", "AMOUNT"]
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type == "PERCENT" ? "نسبة مئوية" : "مبلغ ثابت",
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedType = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: isActive,
                  title: const Text("حالة العرض"),
                  subtitle: Text(
                    isActive ? "نشط" : "غير نشط",
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      isActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
            ElevatedButton(
              onPressed: () {
                // تأكد إن الاسم والقيمة ليست فارغة
                final name = nameController.text.trim();
                final valueText = valueController.text.trim();

                if (name.isEmpty || valueText.isEmpty) {
                  Get.snackbar(
                    "خطأ ⚠️",
                    "الرجاء إدخال جميع الحقول",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade50,
                    colorText: Colors.red.shade700,
                  );
                  return;
                }

                final parsedValue = double.tryParse(valueText);
                if (parsedValue == null) {
                  Get.snackbar(
                    "خطأ ⚠️",
                    "القيمة يجب أن تكون رقمًا صالحًا",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade50,
                    colorText: Colors.red.shade700,
                  );
                  return;
                }

                final updatedOffer = offer.copyWith(
                  name: name,
                  value: parsedValue,
                  type: selectedType,
                  isActive: isActive,
                );

                // تأكد أن الكنترولر محدث صح
                final OfferController controller = Get.find<OfferController>();
                controller.updateOffer(updatedOffer);
                Get.back();

                Get.snackbar(
                  "تم التعديل ✅",
                  "تم تحديث العرض بنجاح",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade50,
                  colorText: Colors.green.shade700,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("حفظ"),
            ),
          ],
        ),
      ),
    );
  }
}
