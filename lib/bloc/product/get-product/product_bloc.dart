import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:grostok/data/repositories/product/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository productRepository;
  bool isLoadMore = false;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<GetProductEvent>(getProduct);
    on<GetMoreProductEvent>(getMoreProduct);
  }

  Future<void> getProduct(event, emit) async {
    emit(GetProductLoading());
    try {
      Map<String, dynamic> response =
          await productRepository.getProductRepo(limit: "10", skip: "0");

      if (response["error"] == true) {
        throw response["message"];
      } else {
        ProductModel productModel = response["data"];
        List<ProductData> productData = productModel.products!;
        emit(GetProductLoaded(
            productData: productData,
            skip: productModel.skip ?? 0,
            limit: productModel.limit ?? 0,
            hasNextPage: productModel.total! > productModel.skip!));
      }
    } catch (e) {
      emit(GetProductError(msg: e.toString()));
    }
  }

  Future<void> getMoreProduct(
      GetMoreProductEvent event, Emitter<ProductState> emit) async {
    final currentState = state as GetProductLoaded;
    int skipParam = currentState.skip;
    int limitParam = currentState.limit;
    bool hasNextPage = currentState.hasNextPage;

    if (isLoadMore == false && currentState.hasNextPage) {
      isLoadMore = true;

      try {
        skipParam = skipParam + 10;
        Map<String, dynamic> response = await productRepository.getProductRepo(
          skip: skipParam.toString(),
          limit: limitParam.toString(),
        );

        ProductModel productModel = response["data"];
        List<ProductData> allProducts = List.from(currentState.productData)
          ..addAll(productModel.products!);

        hasNextPage =
            productModel.total! > (productModel.limit! + productModel.skip!);

        emit(GetProductLoaded(
          productData: allProducts,
          hasNextPage: hasNextPage,
          limit: limitParam,
          skip: skipParam,
        ));
      } catch (e) {
        emit(GetProductError(msg: e.toString()));
      } finally {
        isLoadMore = false;
      }
    }
  }

  
}
