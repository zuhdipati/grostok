import 'package:flutter/material.dart';
import 'package:grostok/widgets/shimmer/box_shimmer.dart';
import 'package:grostok/widgets/shimmer/custom_shimmer.dart';

class ProductListLoad extends StatelessWidget {
  const ProductListLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomShimmer(
          onLoad: GridView.builder(
        shrinkWrap: true,
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65),
        itemBuilder: (context, index) {
          return BoxShimmer(
            radius: 10,
          );
        },
      )),
    );
  }
}
