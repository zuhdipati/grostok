import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/core/services/utils.dart';

part 'detail_product_state.dart';

class DetailProductCubit extends Cubit<DetailProductState> {
  DetailProductCubit() : super(const DetailProductState(isWishlisted: false));

  Future<void> loadWishlistStatus(String idProduct) async {
    emit(state.copyWith(isLoading: true));
    final result = await Utils.isWishlisted(idProduct);
    emit(state.copyWith(isWishlisted: result, isLoading: false));
  }

  Future<void> toggleWishlist(String idProduct) async {
    await Utils.toggleWishlist(idProduct);
    final updatedStatus = await Utils.isWishlisted(idProduct);
    if (updatedStatus) await Utils.setRefreshWishlist(true);
    emit(state.copyWith(isWishlisted: updatedStatus));
  }

  Future<List<String>> getWishlist() async {
    return await Utils.getWishlist();
  }
}
