import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/controllers/auth/login_controller.dart';
import 'package:online_store/controllers/owner/brand_controller.dart';
import 'package:online_store/controllers/owner/category_controller.dart';
import 'package:online_store/controllers/owner/product_controller.dart';
import 'package:online_store/view/screen/owner/BrandsPage.dart';
import 'package:online_store/view/screen/owner/CategoriesPage.dart';
import 'package:online_store/view/screen/owner/OrdersPage.dart';
import 'package:online_store/view/screen/owner/ProductsPage.dart';
import 'package:online_store/view/screen/owner/offers_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final List<String> menuItems = [
    "الصفحة الرئيسية",
    "التصنيفات",
    "الشركات",
    "المنتجات",
    "الطلبات",
    "العروض",
  ];

  // Add controllers
  final BrandController brandController = Get.put(BrandController());
  final CategoryController categoryController = Get.put(CategoryController());
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          menuItems[selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
       
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Header محسّن
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "لوحة التحكم",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "إدارة المتجر",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // القائمة
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                getIconData(index),
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                size: 22,
                              ),
                            ),
                            title: Text(
                              menuItems[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.blue,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Footer
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout_rounded, color: Colors.red),
              ),
              title: const Text(
                "تسجيل الخروج",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Get.defaultDialog(
                  title: "تأكيد",
                  middleText: "هل تريد تسجيل الخروج؟",
                  confirm: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // 🔴 خلفية الزر
                      foregroundColor: Colors.white, // 🤍 لون النص
                    ),
                    onPressed: () {
                      final controller = Get.put(LoginControllerImp());
                      controller.logout();
                    },
                    child: const Text(
                      "نعم",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // اختياري - يخلي الكلمة أوضح
                      ),
                    ),
                  ),

                  cancel: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // ✅ النص أبيض
                      backgroundColor: Colors.grey, // خلفية غامقة
                    ),
                    child: const Text("إلغاء"),
                  ),
                );
              },
            ),

            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     children: [
            //       CircleAvatar(
            //         backgroundColor: Colors.blue.shade100,
            //         child: const Icon(Icons.person, color: Colors.blue),
            //       ),
            //       const SizedBox(width: 12),
            //       // Expanded(
            //       //   child: Column(
            //       //     crossAxisAlignment: CrossAxisAlignment.start,
            //       //     mainAxisSize: MainAxisSize.min,
            //       //     children: [
            //       //       const Text(
            //       //         "المدير",
            //       //         style: TextStyle(
            //       //           fontWeight: FontWeight.bold,
            //       //           fontSize: 14,
            //       //         ),
            //       //       ),
            //       //       Text(
            //       //         "admin@store.com",
            //       //         style: TextStyle(
            //       //           color: Colors.grey.shade600,
            //       //           fontSize: 12,
            //       //         ),
            //       //       ),
            //       //     ],
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      body: _getSelectedPage(),
    );
  }

  Widget _getSelectedPage() {
    switch (selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return CategoryPage();
      case 2:
        return BrandsPage();
      case 3:
        return ProductsPage();
      case 4:
        return OrdersPage();
      case 5:
        return OffersPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ترحيب
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.waving_hand_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "مرحباً بك!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "نظرة عامة على متجرك",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // عنوان الإحصائيات
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  "إحصائيات عامة",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // بطاقات الإحصائيات
            GetBuilder<CategoryController>(
              builder: (_) => _buildStatCard(
                title: "التصنيفات",
                count: categoryController.categories.length,
                icon: Icons.category_rounded,
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                description: "إجمالي عدد التصنيفات في المتجر",
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            GetBuilder<BrandController>(
              builder: (_) => _buildStatCard(
                title: "الشركات",
                count: brandController.brands.length,
                icon: Icons.business_rounded,
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                description: "إجمالي عدد الشركات المسجلة",
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            GetBuilder<ProductController>(
              builder: (_) => _buildStatCard(
                title: "المنتجات",
                count: productController.products.length,
                icon: Icons.shopping_cart_rounded,
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                description: "إجمالي عدد المنتجات المتاحة",
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // معلومات إضافية
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        "نصائح سريعة",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(
                    icon: Icons.add_circle_outline,
                    text: "قم بإضافة تصنيفات وشركات قبل إضافة المنتجات",
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    icon: Icons.edit_outlined,
                    text: "يمكنك تعديل أي عنصر بالضغط على زر التعديل",
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    icon: Icons.visibility_outlined,
                    text: "استخدم حالة 'نشط' للتحكم في ظهور العناصر",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Gradient gradient,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
IconData getIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.category_rounded;
      case 2:
        return Icons.business_rounded;
      case 3:
        return Icons.shopping_cart_rounded;
      case 4: // الطلبات
        return Icons.list_alt_rounded;
      case 5: // العروض
        return Icons.local_offer_rounded;
      default:
        return Icons.help_rounded;
    }
  }

}
