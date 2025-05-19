import 'package:flutter/material.dart';
import 'package:grostok/widgets/shimmer/box_shimmer.dart';
import 'package:grostok/widgets/shimmer/custom_shimmer.dart';

class CategoryTitleLoad extends StatelessWidget {
  const CategoryTitleLoad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      onLoad: Row(
        children: List.generate(
          5,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: BoxShimmer(
                height: 30,
                width: 60,
                radius: 10,
              ),
            );
          },
        ),
      ),
    );
  }
}
