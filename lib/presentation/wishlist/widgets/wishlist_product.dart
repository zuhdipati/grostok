// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:grostok/bloc/wishlist/wishlist_bloc.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/core/routes/app_route.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/product_model.dart';

class WishlistProductWidget extends StatelessWidget {
  const WishlistProductWidget({
    super.key,
    required this.listWishlist,
  });

  final List<ProductData> listWishlist;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: listWishlist.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65),
      itemBuilder: (context, index) {
        ProductData product = listWishlist[index];

        return Bounceable(
          onTap: () async {
            final result = await Navigator.pushNamed(context, AppRoutes.detail,
                arguments: product);
            if (result == true) {
              await Utils.setRefreshWishlist(true);
              context.read<WishlistBloc>().add(GetWishlistEvent());
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0.5,
                      offset: Offset(0, 0.3),
                      color: Colors.black.withValues(alpha: 0.5),
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.thumbnail ?? '',
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.zero),
                                image: DecorationImage(
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.cover,
                                    image: imageProvider)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.favorite, color: Colors.red,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title ?? '',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Text(product.category ?? '',
                              style: TextStyle(fontSize: 11)),
                          Text(Utils.convertDollar(product.price ?? 0),
                              style: TextStyle(fontSize: 13)),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Stock: ${product.stock}",
                                  style: TextStyle(fontSize: 11)),
                              Text("Rating : ${product.rating}",
                                  style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
