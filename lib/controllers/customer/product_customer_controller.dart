import 'package:get/get.dart';
import 'package:online_store/core/services/customer/product_customer_service.dart';
import 'package:online_store/model/product_model.dart';

class ProductCustomerController extends GetxController {
  final ProductCustomerService productService = ProductCustomerService();

  bool isLoading = false;
  List<ProductModel> products = [];
  int? selectedCategoryId;

  // فلترة بسيطة
  double? minPrice;
  double? maxPrice;
  String search = '';

  // فلترة متقدمة
  String? priceFilter; // 'asc' أو 'desc'
  String? selectedCompany;
  List<String> availableCompanies = [];
  List<ProductModel> allProducts = []; // نسخة أصلية من المنتجات

  // بيانات منتج واحد
  ProductModel? productDetails;
  bool isLoadingProductDetails = false;

  // 🔹 قائمة المنتجات المختارة للمقارنة
  List<int> selectedProductIds = [];

  // 🔹 التبديل بين التحديد والإزالة
  void toggleProductSelection(int productId) {
    if (selectedProductIds.contains(productId)) {
      selectedProductIds.remove(productId);
    } else {
      // نسمح بحد أقصى 3 منتجات مثلاً (اختياري)
      if (selectedProductIds.length < 3) {
        selectedProductIds.add(productId);
      } else {
        Get.snackbar(
          "تنبيه",
          "يمكن مقارنة 3 منتجات كحد أقصى",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    update();
  }

  // 🔹 التحقق إن كان المنتج محدد للمقارنة
  bool isProductSelected(int productId) {
    return selectedProductIds.contains(productId);
  }

  // 🔹 مسح التحديد بعد المقارنة
  void clearComparisonSelection() {
    selectedProductIds.clear();
    update();
  }

  // البحث عن منتج
  void searchProducts(String query) {
    search = query;
    List<ProductModel> filtered = List.from(allProducts);

    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // بعد البحث نطبق الفلاتر الباقية (السعر، الشركة)
    if (selectedCompany != null) {
      filtered = filtered
          .where((p) => p.brandId.toString() == selectedCompany)
          .toList();
    }

    if (priceFilter == 'asc') {
      filtered.sort((a, b) => a.priceCents.compareTo(b.priceCents));
    } else if (priceFilter == 'desc') {
      filtered.sort((a, b) => b.priceCents.compareTo(a.priceCents));
    }

    products = filtered;
    update();
  }

  // الفلترة حسب السعر
  void filterByPrice(String order) {
    priceFilter = order;
    _applyFilters();
    update();
  }

  // الفلترة حسب الشركة
  void filterByCompany(String company) {
    if (selectedCompany == company) {
      selectedCompany = null; // إلغاء التحديد
    } else {
      selectedCompany = company;
    }
    _applyFilters();
    update();
  }

  // تطبيق جميع الفلاتر
  void _applyFilters() {
    List<ProductModel> filtered = List.from(allProducts);

    // فلتر الشركة
    // فلتر الشركة (أو الـ brand)
    if (selectedCompany != null && selectedCompany!.isNotEmpty) {
      final int brandId = int.tryParse(selectedCompany!) ?? 0;
      filtered = filtered.where((p) => p.brandId == brandId).toList();
    }

    // فلتر السعر
    if (priceFilter == 'asc') {
      filtered.sort((a, b) => a.priceCents.compareTo(b.priceCents));
    } else if (priceFilter == 'desc') {
      filtered.sort((a, b) => b.priceCents.compareTo(a.priceCents));
    }

    // فلتر البحث
    if (search.isNotEmpty) {
      filtered = filtered
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    products = filtered;
    update();
  }

  // إعادة تعيين الفلاتر
  void clearFilters() {
    priceFilter = null;
    selectedCompany = null;
    products = List.from(allProducts);
    update();
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    selectedCategoryId = categoryId;
    isLoading = true;
    update();

    products = await productService.fetchProductsByCategory(
      categoryId: categoryId,
    );

    // نحفظ نسخة أصلية للفلترة لاحقاً
    allProducts = List.from(products);

    isLoading = false;
    update();
  }

  Future<void> fetchAvailableCompanies() async {
    try {
      isLoading = true;
      update();

      final brands = await productService.fetchBrands();

      availableCompanies = brands.map((b) => b['name'].toString()).toList();

      isLoading = false;
      update();
    } catch (e) {
      print("Fetch Companies Error: $e");
      isLoading = false;
      update();
    }
  }

  // جلب تفاصيل منتج
  Future<void> fetchProductDetails(int productId) async {
    isLoadingProductDetails = true;
    update();

    productDetails = await productService.fetchProductDetails(productId);

    isLoadingProductDetails = false;
    update();
  }

  void applyFilters({String? searchText, double? min, double? max}) async {
    if (selectedCategoryId == null) return;

    search = searchText ?? '';
    minPrice = min;
    maxPrice = max;

    isLoading = true;
    update();

    products = await productService.fetchProductsByCategory(
      categoryId: selectedCategoryId!,
      search: search,
    );

    allProducts = List.from(products);

    isLoading = false;
    update();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
