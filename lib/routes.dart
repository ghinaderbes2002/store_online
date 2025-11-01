import 'package:get/get.dart';
import 'package:online_store/core/constant/App_routes.dart';
import 'package:online_store/view/screen/auth/login.dart';
import 'package:online_store/view/screen/auth/signUp.dart';
import 'package:online_store/view/screen/customer/ProductsByCategory.dart';
import 'package:online_store/view/screen/customer/categories_page.dart';
import 'package:online_store/view/screen/customer/customer_dashboard.dart';
import 'package:online_store/view/screen/customer/home_page.dart';
import 'package:online_store/view/screen/customer/product_details.dart';
import 'package:online_store/view/screen/customer/home_main_page.dart';
import 'package:online_store/view/screen/owner/BrandsPage.dart';
import 'package:online_store/view/screen/owner/CategoriesPage.dart';
import 'package:online_store/view/screen/owner/admin_dashboard.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: "/", page: () => DashboardPage()),

  GetPage(name: AppRoute.login, page: () => Login()),
  GetPage(name: AppRoute.category, page: () => CategoryPage()),

  GetPage(name: AppRoute.signup, page: () => const SignUp()),
  GetPage(name: AppRoute.brands, page: () => BrandsPage()),
  GetPage(name: AppRoute.dashboardCust, page: () => CustomerDashboard()),

  GetPage(name: AppRoute.categories, page: () => CategoriesPage()),

  GetPage(name: AppRoute.home, page: () => HomePage()),
  GetPage(name: AppRoute.homeMain, page: () => HomeMainPage()),

  GetPage(
    name: AppRoute.productsBycategory,
    page: () => ProductsByCategoryPage(),
  ),

  GetPage(name: AppRoute.productDetails, page: () => ProductDetailsPage()),
];
