part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class GetProductLoading extends ProductState {}

final class GetProductLoaded extends ProductState {
  final List<ProductData> productData;
  final int skip;
  final int limit;
  final bool hasNextPage;

  const GetProductLoaded({
    required this.productData,
    required this.skip,
    required this.limit,
    required this.hasNextPage,
  });

  @override
  List<Object> get props => [productData, skip, limit, hasNextPage];
}

final class GetProductError extends ProductState {
  final String msg;

  const GetProductError({required this.msg});
}
