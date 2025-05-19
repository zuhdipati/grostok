import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartStringList = prefs.getStringList('cart') ?? [];

      final cart = cartStringList.map((item) {
        final Map<String, dynamic> decoded = json.decode(item);
        return CartModel.fromJson(decoded);
      }).toList();

      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }

  Future<void> decreaseQuantity(int id) async {
    await Utils.decreaseQuantity(id);
    await loadCart();
  }

   Future<void> increaseQuantity(int id) async {
    await Utils.increaseQuantity(id);
    await loadCart();
  }

  double calculateTotal(List<CartModel> cart) {
    return cart.fold(0.0, (sum, item) => sum + item.price * item.totalQuantity);
  }
}
