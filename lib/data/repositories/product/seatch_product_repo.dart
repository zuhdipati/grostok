import 'package:grostok/data/data-provider/product/search_product.dart';

class SearchProductRepo {
  SearchProductProvider searchProductProvider = SearchProductProvider();

  Future<Map<String, dynamic>> searchProductRepo(
      {required String query,
      required String limit,
      required String skip}) async {
    Map<String, dynamic> dataSearch =
        await searchProductProvider.searchProduct(query, limit, skip);

    if (dataSearch["error"] == true) {
      return {"error": true, "message": "error search product"};
    }

    return {
      "error": false,
      "message": "success search product",
      "data": dataSearch['data']
    };
  }
}
