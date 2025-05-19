import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/data/repositories/product/category_product_repo.dart';

part 'category_product_event.dart';
part 'category_product_state.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  CategoryProductRepo categoryProductRepo;

  CategoryProductBloc(this.categoryProductRepo)
      : super(CategoryProductState()) {
    on<GetCategoryTitleEvent>(_onGetCategoryProduct);
    on<GetProductByCategoryEvent>(_onGetProductByCategory);
    on<GetMoreProductByCategoryEvent>(_onGetMoreProductByCategory);
    on<SearchProductEvent>(_onSearchProduct);
  }

  FutureOr<void> _onGetCategoryProduct(event, emit) async {
    emit(state.copyWith(isLoadingTitle: true, isErrorTitle: false));
    try {
      final response = await categoryProductRepo.getCategoryTitleRepo();
      if (response["error"] == true) throw response["message"];
      List<String> titles = response["data"];
      emit(state.copyWith(categoryTitles: titles, isLoadingTitle: false));
    } catch (e) {
      emit(state.copyWith(isLoadingTitle: false, isErrorTitle: true));
    }
  }

  FutureOr<void> _onGetProductByCategory(event, emit) async {
    try {
      emit(state.copyWith(
          selectedCategory: event.name,
          isLoadingProduct: true,
          products: [],
          isErrorProduct: false));
      final response = await categoryProductRepo.getProductByCategoryRepo(
          name: event.name, limit: "10", skip: "0");
      if (response["error"] == true) throw response["message"];

      ProductModel productData = response["data"];
       List<ProductData> productList = productData.products ?? [];
      emit(state.copyWith(
        products: productList,
        allProducts: productList,
        skip: productData.skip ?? 0,
        limit: productData.limit ?? 0,
        hasNextPage:
            productData.total! > (productData.limit! + productData.skip!),
        isLoadingProduct: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingProduct: false, isErrorProduct: true));
    }
  }

  FutureOr<void> _onGetMoreProductByCategory(event, emit) async {
    int skipParam = state.skip;
    try {
      skipParam = skipParam + 10;
      emit(state.copyWith(
          selectedCategory: event.name,
          isLoadMore: true,
          isErrorProduct: false));
      final response = await categoryProductRepo.getProductByCategoryRepo(
          name: event.name, limit: "${state.limit}", skip: "$skipParam");
      if (response["error"] == true) throw response["message"];

      ProductModel productData = response["data"];
      List<ProductData> productList = List.from(state.products)
        ..addAll(productData.products ?? []);

      emit(state.copyWith(
        products: productList,
        allProducts: productList,
        skip: skipParam,
        limit: productData.limit ?? 0,
        hasNextPage:
            productData.total! > (productData.limit! + productData.skip!),
        isLoadMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadMore: false, isErrorProduct: true));
    }
  }

  FutureOr<void> _onSearchProduct(
      SearchProductEvent event, Emitter<CategoryProductState> emit) {
    final productList = state.allProducts;
    final query = event.query.toLowerCase();
    final results = productList.where((product) {
      return product.title?.toLowerCase().contains(query) ?? false;
    }).toList();

    emit(state.copyWith(products: results));
  }
}
