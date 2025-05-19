import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grostok/core/const/app_assets.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/presentation/home/pages/home.dart';
import 'package:grostok/presentation/category/pages/category.dart';
import 'package:grostok/presentation/wishlist/pages/wishlist.dart';

List<BottomNavigationBarItem> bottomNavItem = [
  BottomNavigationBarItem(
      icon: SvgPicture.asset(AppAssets.homeIcon),
      activeIcon: SvgPicture.asset(AppAssets.homeActiveIcon),
      label: 'Home'),
  BottomNavigationBarItem(
      icon: SvgPicture.asset(AppAssets.categoryIcon),
      activeIcon: SvgPicture.asset(AppAssets.categoryActiveIcon),
      label: 'Category'),
  BottomNavigationBarItem(
      icon: SvgPicture.asset(AppAssets.wishlistIcon),
      activeIcon: SvgPicture.asset(AppAssets.wishlistActiveIcon),
      label: 'Wishlist'),
  // BottomNavigationBarItem(
  //     icon: SvgPicture.asset(AppAssets.trackIcon),
  //     activeIcon: SvgPicture.asset(AppAssets.trackActiveIcon),
  //     label: 'Track'),
];

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            currentIndex = index;
            setState(() {});
          },
          children: [
            HomePage(),
            ProductPage(),
            WishlistPage(),
            // AboutPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavItem,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: AppColors.secondary,
          onTap: (value) {
            pageController.jumpToPage(value);
          },
        ));
  }
}
