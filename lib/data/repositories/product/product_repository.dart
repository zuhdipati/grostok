import 'package:grostok/data/data-provider/product/product_provider.dart';

class ProductRepository {
  ProductProvider productProvider = ProductProvider();

  Future<Map<String, dynamic>> getProductRepo(
      {required String limit, required String skip}) async {
    Map<String, dynamic> dataProduct =
        await productProvider.getProduct(limit, skip);

    if (dataProduct["error"] == true) {
      return {"error": true, "message": "error get product"};
    }

    return {
      "error": false,
      "message": "success get product",
      "data": dataProduct['data']
    };
  }
}
