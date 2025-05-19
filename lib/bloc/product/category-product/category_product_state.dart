part of 'category_product_bloc.dart';

class CategoryProductState extends Equatable {
  final String selectedCategory;
  final List<String> categoryTitles;
  final List<ProductData> products;
  final List<ProductData> allProducts;
  final int skip;
  final int limit;
  final bool hasNextPage;
  final bool isLoadingTitle;
  final bool isLoadingProduct;
  final bool isLoadMore;
  final bool isErrorTitle;
  final bool isErrorProduct;

  const CategoryProductState({
    this.selectedCategory = '',
    this.categoryTitles = const [],
    this.products = const [],
    this.allProducts = const [],
    this.skip = 0,
    this.limit = 10,
    this.hasNextPage = true,
    this.isLoadingTitle = false,
    this.isLoadingProduct = false,
    this.isLoadMore = false,
    this.isErrorTitle = false,
    this.isErrorProduct = false,
  });

  CategoryProductState copyWith({
    String? selectedCategory,
    List<String>? categoryTitles,
    List<ProductData>? products,
    List<ProductData>? allProducts,
    int? skip,
    int? limit,
    bool? hasNextPage,
    bool? isLoadingTitle,
    bool? isLoadingProduct,
    bool? isLoadMore,
    bool? isErrorTitle,
    bool? isErrorProduct,
  }) {
    return CategoryProductState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categoryTitles: categoryTitles ?? this.categoryTitles,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingTitle: isLoadingTitle ?? this.isLoadingTitle,
      isLoadingProduct: isLoadingProduct ?? this.isLoadingProduct,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      isErrorTitle: isErrorTitle ?? this.isErrorTitle,
      isErrorProduct: isErrorProduct ?? this.isErrorProduct,
    );
  }

  @override
  List<Object?> get props => [
        selectedCategory,
        categoryTitles,
        products,
        allProducts,
        skip,
        limit,
        hasNextPage,
        isLoadingTitle,
        isLoadingProduct,
        isLoadMore,
        isErrorTitle,
        isErrorProduct
      ];
}
