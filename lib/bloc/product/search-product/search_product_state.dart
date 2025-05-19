part of 'search_product_bloc.dart';

sealed class SearchProductState extends Equatable {
  const SearchProductState(this.query);
  final String query;

  @override
  List<Object> get props => [];
}

final class SearchProductInitial extends SearchProductState {
  const SearchProductInitial(super.query);
}

final class SearchProductLoading extends SearchProductState {
  const SearchProductLoading(super.query);
}

final class SearchProductLoaded extends SearchProductState {
  final List<ProductData> productData;
  final int skip;
  final int limit;
  final bool hasNextPage;

  const SearchProductLoaded(super.query, {
    required this.productData,
    required this.skip,
    required this.limit,
    required this.hasNextPage,
  });

  @override
  List<Object> get props => [productData, skip, limit, hasNextPage];
}

final class SearchProductError extends SearchProductState {
  const SearchProductError(super.query);
}
