String baseUrl = "https://dummyjson.com";
String urlProduct = "$baseUrl/products";
String urlCarts = "$baseUrl/carts";

String urlGetProduct(String limit, String skip) =>
    "$urlProduct?limit=$limit&skip=$skip";

String urlGetCategoryProduct = "$urlProduct/category-list";

String urlGetProductByCategory(String name, String limit, String skip) =>
    "$urlProduct/category/$name?limit=$limit&skip=$skip";

String urlGetSingleProduct(int idProduct) => "$urlProduct/$idProduct";

String urlSearchProduct(String query, String limit, String skip) =>
    "$urlProduct/search?q=$query&limit=$limit&skip=$skip";

String urlAddCart = "$urlCarts/add";
