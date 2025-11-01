import 'package:flutter/material.dart';
import 'package:online_store/view/screen/customer/categories_page.dart';
import 'package:online_store/view/screen/customer/home_page.dart';
import 'package:online_store/view/screen/customer/orders_customer.dart';
import 'package:online_store/view/screen/customer/profile_page.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomePage(), // الصفحة الرئيسية
    CategoriesPage(), // التصنيفات
    OrdersPage(), // الطلبات
     ProfilePage(), // الملف الشخصي
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: "التصنيفات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "طلباتي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "البروفايل",
          ),
        ],
      ),
    );
  }
}
