import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/core/routes/app_route.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/add_checkout_model.dart';
import 'package:grostok/data/models/cart_model.dart';
import 'package:grostok/presentation/cart/cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            cartList(),
            totalCheckout(context),
          ],
        ),
      ),
    );
  }

  Padding cartList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListView(
        shrinkWrap: true,
        children: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartError) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is CartLoaded) {
                return Column(
                  children: [
                    Column(
                        children: List.generate(
                      state.cart.length,
                      (index) {
                        CartModel cart = state.cart[index];
                        CartCubit cubit = context.read<CartCubit>();
                        return cartProduct(cart, cubit);
                      },
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Press checkout to check the discount",
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  SizedBox cartProduct(CartModel cart, CartCubit cubit) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: CachedNetworkImage(
              imageUrl: cart.image,
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${cart.name} - ${cart.category} - ${cart.brand}"),
                  Text(
                    Utils.convertDollar(cart.price),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Quantity:"),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await cubit.increaseQuantity(cart.id);
                            },
                            child: Icon(Icons.add,
                                color: AppColors.secondary, size: 18),
                          ),
                          SizedBox(width: 10),
                          Text("${cart.totalQuantity}"),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              await cubit.decreaseQuantity(cart.id);
                            },
                            child: Icon(Icons.remove,
                                color: AppColors.secondary, size: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Positioned totalCheckout(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded) {
                final totalPrice =
                    context.read<CartCubit>().calculateTotal(state.cart);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text("Total:"),
                        Text(
                          Utils.convertDollar(totalPrice),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              foregroundColor: Colors.white),
                          onPressed: () {
                            state.cart.isEmpty
                                ? Fluttertoast.showToast(
                                    backgroundColor: Colors.red,
                                    msg: "No Product in cart")
                                : Navigator.pushNamed(
                                    context, AppRoutes.checkout,
                                    arguments: List.generate(
                                      state.cart.length,
                                      (index) {
                                        CartModel cart = state.cart[index];
                                        return ProductItem(
                                            id: cart.id,
                                            quantity: cart.totalQuantity);
                                      },
                                    ));
                          },
                          child: Text("Checkout")),
                    )
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
