import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/bloc/checkout/checkout_bloc.dart';
import 'package:grostok/bloc/product/category-product/category_product_bloc.dart';
import 'package:grostok/bloc/product/get-product/product_bloc.dart';
import 'package:grostok/bloc/product/search-product/search_product_bloc.dart';
import 'package:grostok/bloc/wishlist/wishlist_bloc.dart';
import 'package:grostok/data/models/add_checkout_model.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/data/repositories/checkout/checkout_repository.dart';
import 'package:grostok/data/repositories/product/category_product_repo.dart';
import 'package:grostok/data/repositories/product/product_repository.dart';
import 'package:grostok/data/repositories/product/seatch_product_repo.dart';
import 'package:grostok/data/repositories/wishlist/wishlist_repository.dart';
import 'package:grostok/presentation/cart/pages/cart.dart';
import 'package:grostok/presentation/cart/cubit/cart_cubit.dart';
import 'package:grostok/presentation/checkout/pages/checkout.dart';
import 'package:grostok/presentation/detail_product/cubit/detail_product_cubit.dart';
import 'package:grostok/presentation/detail_product/pages/detail_product.dart';
import 'package:grostok/presentation/navigation/pages/index.dart';
import 'package:grostok/presentation/splash/cubit/splash_cubit.dart';
import 'package:grostok/presentation/splash/pages/splash.dart';

class AppRoutes {
  static const String navigation = '/navigation';
  static const String splash = '/splash';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String detail = '$navigation/detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final ProductRepository productRepository = ProductRepository();
    final CategoryProductRepo categoryProductRepo = CategoryProductRepo();
    final WishlistRepository wishlistRepository = WishlistRepository();
    final SearchProductRepo searchRepository = SearchProductRepo();
    final CheckoutRepository cartRepository = CheckoutRepository();

    switch (settings.name) {
      case navigation:
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ProductBloc>(
                        create: (_) => ProductBloc(productRepository)
                          ..add(GetProductEvent())),
                    BlocProvider<CategoryProductBloc>(
                      create: (_) => CategoryProductBloc(categoryProductRepo)
                        ..add(GetCategoryTitleEvent())
                        ..add(GetProductByCategoryEvent("beauty")),
                    ),
                    BlocProvider<WishlistBloc>(
                      create: (context) => WishlistBloc(wishlistRepository)
                        ..add(GetWishlistEvent()),
                    ),
                    BlocProvider<SearchProductBloc>(
                        create: (context) =>
                            SearchProductBloc(searchRepository)),
                  ],
                  child: NavigationPage(),
                ));
      case splash:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SplashCubit()..displaySplash(),
                  child: const SplashPage(),
                ));
      case detail:
        final product = settings.arguments as ProductData;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                DetailProductCubit()..loadWishlistStatus("${product.id}"),
            child: DetailProductPage(product: product),
          ),
          settings: settings,
        );
      case cart:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CartCubit()..loadCart(),
            child: CartPage(),
          ),
        );
      case checkout:
        final listItem = settings.arguments as List<ProductItem>;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CheckoutBloc(cartRepository)
              ..add(AddToCheckoutEvent(AddToCheckoutRequestModel(
                userId: 8,
                products: listItem,
              ))),
            child: CheckoutPage(),
          ),
          settings: settings,
        );
      default:
        return onError();
    }
  }

  static CupertinoPageRoute<dynamic> onError() {
    return CupertinoPageRoute(
      builder: (context) {
        return const Scaffold(
          body: Center(
            child: Text("ERROR"),
          ),
        );
      },
    );
  }
}
