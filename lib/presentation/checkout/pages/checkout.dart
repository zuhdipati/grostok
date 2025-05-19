import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grostok/bloc/checkout/checkout_bloc.dart';
import 'package:grostok/core/const/app_colors.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/checkout_model.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              Container(color: AppColors.background, height: 10),
              address(),
              Container(color: AppColors.background, height: 10),
              blocCheckout(),
            ],
          ),
          Positioned(
            bottom: 30,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    foregroundColor: Colors.white),
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Sorry, this feature is not available yet.",
                      backgroundColor: Colors.red);
                },
                child: Text("Order Now")),
          ),
        ],
      ),
    );
  }

  Padding address() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Alamat Pengiriman"),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(width: 4, color: Colors.black)),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "Sorry, this feature is not available yet.",
                        backgroundColor: Colors.red);
                  },
                  child: Text("Tambahkan Alamat"))
            ],
          ),
          Text("Zuhdi Abdillah"),
          Text("0992 1234 8911"),
          Text(
              "Jl. Melati No. 45, RT 03 / RW 02, Sukamaju, Cimanggis, Depok, Jawa Barat, 16452")
        ],
      ),
    );
  }

  BlocBuilder<CheckoutBloc, CheckoutState> blocCheckout() {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state is AddCheckoutLoading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppColors.secondary,
              ),
            ),
          );
        }
        if (state is AddCheckoutError) {
          return Center(
            child: Text("Sorry, Failed to get Checkout Data"),
          );
        }
        if (state is AddCheckoutLoaded) {
          return listCheckout(state);
        }
        return SizedBox();
      },
    );
  }

  Column listCheckout(AddCheckoutLoaded state) {
    double calculateTotal(List<CheckoutProduct> cart) {
      return cart.fold(
          0.0, (sum, item) => sum + item.discountedPrice * item.quantity);
    }

    return Column(
      children: [
        Column(
          children: List.generate(
            state.response.products.length,
            (index) {
              CheckoutProduct checkout = state.response.products[index];
              return SizedBox(
                height: 120,
                child: Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: checkout.thumbnail,
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
                            Text(checkout.title),
                            Row(
                              children: [
                                Text(
                                  Utils.convertDollar(checkout.price),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(Disc ${checkout.discountPercentage.floor()}%)",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            Text(
                              Utils.convertDollar(
                                  checkout.discountedPrice.toDouble()),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Quantity:"),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text("${checkout.quantity}"),
                                    SizedBox(width: 10),
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
            },
          ),
        ),
        Container(color: AppColors.background, height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Order (${state.response.products.length} Product/s)",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Expanded(
                  child: Text(
                Utils.convertDollar(calculateTotal(state.response.products)),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                textAlign: TextAlign.end,
              ))
            ],
          ),
        )
      ],
    );
  }
}
