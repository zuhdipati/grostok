// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grostok/core/const/app_assets.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/core/routes/app_route.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/add_checkout_model.dart';
import 'package:grostok/data/models/cart_model.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/presentation/detail_product/cubit/detail_product_cubit.dart';

class DetailProductPage extends StatelessWidget {
  final ProductData product;

  const DetailProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(product, context),
      body: Stack(
        children: [
          ListView(
            children: [
              imageProduct(context, product),
              Container(color: AppColors.background, height: 15),
              namePriceProduct(product),
              Container(color: AppColors.background, height: 15),
              detailProduct(product),
              Container(color: AppColors.background, height: 15),
              product.reviews == null ? SizedBox() : reviews(product),
              SizedBox(height: 80)
            ],
          ),
          cartBuyNow(context, product).animate().fade()
        ],
      ),
    );
  }

  AppBar appBar(ProductData product, BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () async {
            final wishlist = await Utils.getWishlist();

            if (!wishlist.contains("${product.id}")) {
              Navigator.pop(context, true);
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back_ios_new)),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(AppAssets.cartIcon),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    minRadius: 7,
                    backgroundColor: Colors.red,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(AppAssets.sendIcon),
        )
      ],
    );
  }

  SizedBox imageProduct(BuildContext context, ProductData product) {
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: CachedNetworkImage(
        imageUrl: product.thumbnail ?? '',
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  image: imageProvider)),
        ),
      ),
    );
  }

  Padding namePriceProduct(ProductData product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.convertDollar(product.price ?? 0),
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
              ),
              BlocBuilder<DetailProductCubit, DetailProductState>(
                builder: (context, state) {
                  final cubit = context.read<DetailProductCubit>();

                  return GestureDetector(
                    onTap: () async {
                      final wishlist = await cubit.getWishlist();
                      if (wishlist.length >= 5 &&
                          !wishlist.contains("${product.id}")) {
                        Fluttertoast.showToast(
                          msg: "Maaf, wishlist tidak bisa lebih dari 5",
                          backgroundColor: Colors.red,
                          textColor: AppColors.background,
                        );
                      } else {
                        cubit.toggleWishlist("${product.id}");
                      }
                    },
                    child: state.isWishlisted
                        ? SvgPicture.asset(
                            AppAssets.wishlistActiveIcon,
                            colorFilter:
                                ColorFilter.mode(Colors.red, BlendMode.srcIn),
                          )
                        : SvgPicture.asset(AppAssets.wishlistIcon),
                  );
                },
              )
            ],
          ),
          SizedBox(height: 10),
          Text(
            [product.title, product.brand, product.category]
                .where((element) =>
                    element != null && element.toString().isNotEmpty)
                .join(' - '),
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 20),
          Text(
            "${product.stock ?? 0} ${product.availabilityStatus}",
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Padding detailProduct(ProductData product) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Produk",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(
            "${product.title} - ${product.brand} - ${product.category} ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Divider(
            color: AppColors.background,
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Condition"),
                  Text("Category"),
                  Text("Warranty Info."),
                  Text("Shipping Info."),
                  Text("Return Policy"),
                ],
              ),
              SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("New"),
                  Text("${product.category}"),
                  Text("${product.warrantyInformation}"),
                  Text("${product.shippingInformation}"),
                  Text("${product.returnPolicy}"),
                ],
              )
            ],
          ),
          Divider(
            color: AppColors.background,
            height: 30,
          ),
          Text("${product.title}"),
          SizedBox(height: 10),
          Text("${product.description}"),
        ],
      ),
    );
  }

  Padding reviews(ProductData product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Reviews:"),
          SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  product.reviews?.length ?? 0,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      width: 250,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0.5,
                              offset: Offset(0, 1),
                              color: Colors.black.withValues(alpha: 0.5),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(product.reviews?[index].reviewerName ?? '',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(
                              "(${product.reviews?[index].reviewerEmail})",
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(height: 12),
                            RatingBar.builder(
                              initialRating:
                                  product.reviews?[index].rating.toDouble() ??
                                      0,
                              minRating: 1,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text(product.reviews?[index].comment ?? ''),
                            SizedBox(height: 5),
                            Text(product.reviews?[index].date.toString() ?? '',
                                style: TextStyle(fontSize: 8)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  Positioned cartBuyNow(BuildContext context, ProductData product) {
    return Positioned(
        bottom: 0,
        child: Container(
          color: AppColors.background,
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(width: 4, color: Colors.black)),
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      Fluttertoast.showToast(
                          msg: "${product.title} Berhasil Ditambah ke Cart",
                          textColor: AppColors.secondary,
                          backgroundColor: AppColors.background);
                      await Utils.addToCart(CartModel(
                          id: product.id ?? 0,
                          totalQuantity: 1,
                          image: product.thumbnail ?? '',
                          name: product.title ?? '',
                          category: product.category ?? '',
                          brand: product.brand ?? '',
                          price: product.price ?? 0));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        AppAssets.cartIcon,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.checkout,
                            arguments: [
                              ProductItem(id: product.id ?? 0, quantity: 1)
                            ]);
                      },
                      child: Text(
                        "Buy Now",
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              )),
        ));
  }
}
