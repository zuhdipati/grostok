import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/core/services/utils.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/data/repositories/wishlist/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistRepository wishlistRepository;
  WishlistBloc(this.wishlistRepository) : super(WishlistInitial()) {
    on<GetWishlistEvent>(getWishlist);
  }

  FutureOr<void> getWishlist(event, emit) async {
    emit(WishlistLoading());
    try {
      final idProducts = await Utils.getWishlist();
      await Utils.setRefreshWishlist(false);
      Map<String, dynamic> response = await wishlistRepository
          .getWishlistProducts(idProducts.map(int.parse).toList());

      if (response["error"] == true) {
        throw response["message"];
      } else {
        List<ProductData> wishlistData = response['data'];
        emit(WishlistLoaded(wishlistData: wishlistData));
      }
    } catch (e) {
      log("$e");
      emit(WishlistError());
    }
  }
}
