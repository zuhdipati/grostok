import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/data/repositories/product/seatch_product_repo.dart';

part 'search_product_event.dart';
part 'search_product_state.dart';

class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  SearchProductRepo seatchRepository;
  bool isLoadMore = false;

  SearchProductBloc(this.seatchRepository) : super(SearchProductInitial("")) {
    on<GetSearchProductEvent>(onGetSearchProduct);
    on<GetMoreSearchProductEvent>(
      (event, emit) async {
        final currentState = state as SearchProductLoaded;
        int skipParam = currentState.skip;

        if (currentState.hasNextPage) {
          isLoadMore = true;
          skipParam += 10;
          try {
            Map<String, dynamic> response =
                await seatchRepository.searchProductRepo(
              query: event.query,
              limit: "10",
              skip: "$skipParam",
            );
            if (response["error"] == true) {
              throw response["message"];
            } else {
              ProductModel productModel = response["data"];
              List<ProductData> allProducts =
                  List.from(currentState.productData)
                    ..addAll(productModel.products!);

              emit(SearchProductLoaded(currentState.query,
                  productData: allProducts,
                  skip: productModel.skip ?? 0,
                  limit: productModel.limit ?? 0,
                  hasNextPage: productModel.total! >
                      (productModel.limit! + productModel.skip!)));
            }
          } catch (e) {
            log("$e");
          } finally {
            isLoadMore = false;
          }
        }
      },
    );
  }

  FutureOr<void> onGetSearchProduct(event, emit) async {
    emit(SearchProductLoading(state.query));
    try {
      Map<String, dynamic> response = await seatchRepository.searchProductRepo(
          query: event.query, limit: "10", skip: "0");
      if (response["error"] == true) {
        throw response["message"];
      } else {
        ProductModel productModel = response["data"];
        List<ProductData> productData = productModel.products!;
        emit(SearchProductLoaded(
          state.query,
          productData: productData,
          skip: productModel.skip ?? 0,
          limit: productModel.limit ?? 0,
          hasNextPage:
              productModel.total! > (productModel.limit! + productModel.skip!),
        ));
      }
    } catch (e) {
      log("$e");
    }
  }
}
