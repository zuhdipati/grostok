part of 'detail_product_cubit.dart';

class DetailProductState {
  final bool isWishlisted;
  final bool isLoading;
  final String? error;

  const DetailProductState({
    required this.isWishlisted,
    this.isLoading = false,
    this.error,
  });

  DetailProductState copyWith({
    bool? isWishlisted,
    bool? isLoading,
    String? error,
  }) {
    return DetailProductState(
      isWishlisted: isWishlisted ?? this.isWishlisted,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
