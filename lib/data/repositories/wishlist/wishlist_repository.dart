import 'dart:developer';

import 'package:grostok/data/data-provider/wishlist/wishlist_provider.dart';
import 'package:grostok/data/models/product_model.dart';

class WishlistRepository {
  WishlistProvider wishlistProvider = WishlistProvider();

  Future<Map<String, dynamic>> getWishlistProducts(List<int> ids) async {
    List<ProductData> products = [];

    for (int id in ids) {
      try {
        final product = await wishlistProvider.getCategoryProduct(id);
        
        if (product["error"] == true) {
          return {
            "error": true,
            "message": "error get product",
          };
        }

        products.add(product['data']);
      } catch (e) {
        log('Gagal ambil produk ID $id: $e');
      }
    }

    return {
      "error": false,
      "message": "success get product",
      "data": products,
    };
  }
}
