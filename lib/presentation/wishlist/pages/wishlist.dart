// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/bloc/wishlist/wishlist_bloc.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/presentation/wishlist/widgets/wishlist_product.dart';
import 'package:grostok/widgets/product_list_load.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final isRefresh = await Utils.isRefreshWishlist();
    if (isRefresh) {
      context.read<WishlistBloc>().add(GetWishlistEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Wishlist",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return ProductListLoad();
            }
            if (state is WishlistError) {
              return Center(child: Text("Error, Please try again"));
            }

            if (state is WishlistLoaded) {
              List<ProductData> listWishlist = state.wishlistData;
              return listWishlist.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: Center(
                        child: Text("No Wishlisht yet."),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: WishlistProductWidget(listWishlist: listWishlist)
                          .animate()
                          .fadeIn()
                          .move());
            }

            return SizedBox();
          },
        ),
        SizedBox(height: 30)
      ],
    ));
  }
}
