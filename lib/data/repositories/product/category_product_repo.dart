import 'package:grostok/data/data-provider/product/category_product_provider.dart';

class CategoryProductRepo {
  CategoryProductProvider categoryProductProvider = CategoryProductProvider();

  Future<Map<String, dynamic>> getCategoryTitleRepo() async {
    Map<String, dynamic> dataProduct =
        await categoryProductProvider.getCategoryProduct();

    if (dataProduct["error"] == true) {
      return {
        "error": true,
        "message": "error get category product",
      };
    }

    return {
      "error": false,
      "message": "success get category product",
      "data": dataProduct['data']
    };
  }

  Future<Map<String, dynamic>> getProductByCategoryRepo(
      {required String name,
      required String limit,
      required String skip}) async {
    Map<String, dynamic> dataProduct =
        await categoryProductProvider.getProductByCategory(name, limit, skip);

    if (dataProduct["error"] == true) {
      return {
        "error": true,
        "message": "error get category product",
      };
    }

    return {
      "error": false,
      "message": "success get category product",
      "data": dataProduct['data']
    };
  }
}
