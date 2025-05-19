import 'dart:convert';

import 'package:grostok/data/models/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static String convertDollar(double dollarAmount,
      {double exchangeRate = 16000}) {
    double rupiah = dollarAmount * exchangeRate;

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(rupiah);
  }

  static Future<void> toggleWishlist(String idProduct) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    if (wishlist.contains(idProduct)) {
      wishlist.remove(idProduct);
    } else {
      wishlist.insert(0, idProduct);
    }

    await prefs.setStringList('wishlist', wishlist);
  }

  static Future<List<String>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('wishlist') ?? [];
  }

  static Future<bool> isWishlisted(String idProduct) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('wishlist')?.contains(idProduct) ?? false;
  }

  static Future<void> setRefreshWishlist(bool refresh) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('refreshWishlist', refresh);
  }

  static Future<bool> isRefreshWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('refreshWishlist') ?? false;
  }

  static Future<void> addToCart(CartModel newProduct) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cartJsonList = prefs.getStringList('cart') ?? [];

    List<CartModel> cart = cartJsonList
        .map((item) => CartModel.fromJson(jsonDecode(item)))
        .toList();

    final existingIndex = cart.indexWhere((item) => item.id == newProduct.id);

    if (existingIndex != -1) {
      cart[existingIndex].totalQuantity += newProduct.totalQuantity;
    } else {
      cart.add(newProduct);
    }

    List<String> updatedCartJson =
        cart.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList('cart', updatedCartJson);
  }

  static Future<void> decreaseQuantity(int productId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cartJsonList = prefs.getStringList('cart') ?? [];

    List<CartModel> cart = cartJsonList
        .map((item) => CartModel.fromJson(jsonDecode(item)))
        .toList();

    final index = cart.indexWhere((item) => item.id == productId);

    if (index != -1) {
      if (cart[index].totalQuantity > 1) {
        cart[index].totalQuantity -= 1;
      } else {
        cart.removeAt(index);
      }

      List<String> updatedCartJson =
          cart.map((item) => jsonEncode(item.toJson())).toList();

      await prefs.setStringList('cart', updatedCartJson);
    }
  }

  static Future<void> increaseQuantity(int productId) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cartJsonList = prefs.getStringList('cart') ?? [];

    List<CartModel> cart = cartJsonList
        .map((item) => CartModel.fromJson(jsonDecode(item)))
        .toList();

    final index = cart.indexWhere((item) => item.id == productId);

    if (index != -1) {
      cart[index].totalQuantity += 1;

      List<String> updatedCartJson =
          cart.map((item) => jsonEncode(item.toJson())).toList();

      await prefs.setStringList('cart', updatedCartJson);
    }
  }

  static Future<List<String>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('cart') ?? [];
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cart');
  }
}
