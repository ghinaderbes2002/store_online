import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:online_store/controllers/owner/offer_controller.dart';
import 'package:online_store/controllers/owner/product_controller.dart';
import 'package:online_store/model/offer_model.dart';
import 'package:online_store/model/product_model.dart';

class OffersPage extends StatelessWidget {
  final OfferController controller = Get.put(OfferController());
  final ProductController productController = Get.put(ProductController());

  OffersPage({super.key});

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
              // Header مع زر الإضافة
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_offer_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "إدارة العروض",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddOfferDialog(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text("إضافة عرض"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
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
                              "قم بإضافة عرض جديد",
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
                                          value: offer.productTargets
                                              .map((p) {
                                                final product =
                                                    productController.products
                                                        .firstWhere(
                                                          (prod) =>
                                                              prod.id ==
                                                              p.productId,
                                                          orElse: () =>
                                                              ProductModel(
                                                                id: 0,
                                                                name:
                                                                    'غير معروف',
                                                                sku: '',
                                                                priceCents: 0,
                                                                stockQty: 0,
                                                                isActive: false,
                                                              ),
                                                        );
                                                return product.name;
                                              })
                                              .join(', '),

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

  // نافذة إضافة عرض جديد
  void _showAddOfferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
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
              const Text("إضافة عرض جديد"),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: controller.formState,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? "الاسم مطلوب"
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // القيمة
                  TextFormField(
                    controller: controller.valueController,
                    decoration: InputDecoration(
                      labelText: "القيمة",
                      hintText: "0",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.trim().isEmpty
                        ? "القيمة مطلوبة"
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // نوع العرض
                  DropdownButtonFormField<String>(
                    value: controller.type,
                    decoration: InputDecoration(
                      labelText: "نوع العرض",
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
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
                          controller.type = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // تاريخ البداية
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat(
                        'yyyy-MM-dd – kk:mm',
                      ).format(controller.startsAt),
                    ),
                    decoration: InputDecoration(
                      labelText: "تاريخ البداية",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: Get.context!,
                        initialDate: controller.startsAt,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: Get.context!,
                          initialTime: TimeOfDay.fromDateTime(
                            controller.startsAt,
                          ),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            controller.startsAt = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // تاريخ النهاية
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat(
                        'yyyy-MM-dd – kk:mm',
                      ).format(controller.endsAt),
                    ),
                    decoration: InputDecoration(
                      labelText: "تاريخ النهاية",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: Get.context!,
                        initialDate: controller.endsAt,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: Get.context!,
                          initialTime: TimeOfDay.fromDateTime(
                            controller.endsAt,
                          ),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            controller.endsAt = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // الحالة
                  SwitchListTile(
                    value: controller.isActive,
                    title: const Text("حالة العرض"),
                    subtitle: Text(controller.isActive ? "نشط" : "غير نشط"),
                    activeColor: Colors.green,
                    onChanged: (val) {
                      setState(() {
                        controller.isActive = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // اختيار المنتجات
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: "اختر المنتجات",
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    items: productController.products
                        .map(
                          (product) => DropdownMenuItem(
                            value: product.id,
                            child: Text(product.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null && !controller.productIds.contains(val)) {
                        setState(() {
                          controller.productIds.add(val);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),

                  // عرض المنتجات المختارة
                  Wrap(
                    spacing: 8,
                    children: controller.productIds.map((id) {
                      final product = productController.products.firstWhere(
                        (p) => p.id == id,
                      );
                      return Chip(
                        label: Text(product.name),
                        onDeleted: () {
                          setState(() {
                            controller.productIds.remove(id);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
            ElevatedButton.icon(
              onPressed: () {
                controller.createOffer();
                Get.back();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text("إضافة"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نافذة تعديل العرض
  void _showEditDialog(BuildContext context, OfferModel offer) {
    final nameController = TextEditingController(text: offer.name);
    final valueController = TextEditingController(text: offer.value.toString());
    String selectedType = offer.type;
    bool isActive = offer.isActive;
    DateTime startsAt = offer.startsAt ?? DateTime.now();
    DateTime endsAt =
        offer.endsAt ?? DateTime.now().add(const Duration(days: 7));

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
                // اسم العرض
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

                // القيمة
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: "القيمة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // نوع العرض
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

                // تاريخ البداية
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd – kk:mm').format(startsAt),
                  ),
                  decoration: InputDecoration(
                    labelText: "تاريخ البداية",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: startsAt,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startsAt),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          startsAt = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),

                // تاريخ النهاية
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd – kk:mm').format(endsAt),
                  ),
                  decoration: InputDecoration(
                    labelText: "تاريخ النهاية",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endsAt,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(endsAt),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          endsAt = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 12),

                // الحالة
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
                  startsAt: startsAt,
                  endsAt: endsAt,
                );

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
