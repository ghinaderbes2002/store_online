import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/model/offer_model.dart';
import 'package:online_store/view/screen/customer/FullImagePage.dart';

class OfferDetailsPage extends StatelessWidget {
  OfferDetailsPage({super.key});

  final OfferModel offer = Get.arguments['offer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.blue),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header العرض
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge عرض خاص
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "عرض خاص",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // اسم العرض
                    Text(
                      offer.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // قيمة الخصم
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        offer.type == "PERCENT"
                            ? "خصم ${offer.value}%"
                            : "خصم ${offer.value} ل.س",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // محتوى الصفحة
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // بطاقة التواريخ
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "تاريخ البداية",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      offer.startsAt != null
                                          ? offer.startsAt!
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]
                                          : 'غير محدد',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(color: Colors.grey.shade200, height: 1),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.event_available_rounded,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "تاريخ الانتهاء",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      offer.endsAt != null
                                          ? offer.endsAt!
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]
                                          : 'غير محدد',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // المنتجات المشمولة
                    if (offer.productTargets.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.blue,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "المنتجات المشمولة",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...offer.productTargets.map((target) {
                        final product = target.product;
                        if (product == null) return const SizedBox.shrink();

                        // داخل map على offer.productTargets
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header المنتج (صورة + اسم)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // صورة المنتج
                                    if (product.imageUrl != null &&
                                        product.imageUrl!.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          // لما تضغط على الصورة تفتح صفحة جديدة
                                          Get.to(
                                            () => FullImagePage(
                                              imageUrl: product.imageUrl!,
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            product.imageUrl!,
                                            width: double.infinity,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.shopping_bag,
                                          size: 60,
                                          color: Colors.blue,
                                        ),
                                      ),

                                    const SizedBox(height: 12),

                                    // اسم المنتج
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // وصف المنتج
                                    if (product.description != null &&
                                        product.description!.isNotEmpty)
                                      Text(
                                        product.description!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // باقي تفاصيل المنتج (السعر، الكمية، العلامة التجارية...)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _buildProductInfo(
                                      Icons.attach_money,
                                      "السعر",
                                      "${(product.priceCents / 100).toStringAsFixed(0)} ل.س",
                                    ),
                                    const SizedBox(height: 12),
                                    _buildProductInfo(
                                      Icons.inventory_2_outlined,
                                      "الكمية المتوفرة",
                                      "${product.stockQty} قطعة",
                                    ),
                                    if (product.brand != null) ...[
                                      const SizedBox(height: 12),
                                      _buildProductInfo(
                                        Icons.business_outlined,
                                        "العلامة التجارية",
                                        product.brand!.name,
                                      ),
                                    ],
                                    if (product.category != null) ...[
                                      const SizedBox(height: 12),
                                      _buildProductInfo(
                                        Icons.category_outlined,
                                        "التصنيف",
                                        product.category!.name,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ] else
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "لا توجد منتجات مشمولة",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "هذا العرض لا يحتوي على منتجات حالياً",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
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
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
