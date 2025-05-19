import 'dart:convert';

CheckoutModel checkoutModelFromJson(String str) => CheckoutModel.fromJson(json.decode(str));

String checkoutModelToJson(CheckoutModel data) => json.encode(data.toJson());

class CheckoutModel {
    int id;
    List<CheckoutProduct> products;
    double total;
    int discountedTotal;
    int userId;
    int totalProducts;
    int totalQuantity;

    CheckoutModel({
        required this.id,
        required this.products,
        required this.total,
        required this.discountedTotal,
        required this.userId,
        required this.totalProducts,
        required this.totalQuantity,
    });

    factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
        id: json["id"],
        products: List<CheckoutProduct>.from(json["products"].map((x) => CheckoutProduct.fromJson(x))),
        total: json["total"]?.toDouble(),
        discountedTotal: json["discountedTotal"],
        userId: json["userId"],
        totalProducts: json["totalProducts"],
        totalQuantity: json["totalQuantity"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total": total,
        "discountedTotal": discountedTotal,
        "userId": userId,
        "totalProducts": totalProducts,
        "totalQuantity": totalQuantity,
    };
}

class CheckoutProduct {
    int id;
    String title;
    double price;
    int quantity;
    double total;
    double discountPercentage;
    int discountedPrice;
    String thumbnail;

    CheckoutProduct({
        required this.id,
        required this.title,
        required this.price,
        required this.quantity,
        required this.total,
        required this.discountPercentage,
        required this.discountedPrice,
        required this.thumbnail,
    });

    factory CheckoutProduct.fromJson(Map<String, dynamic> json) => CheckoutProduct(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        total: json["total"]?.toDouble(),
        discountPercentage: json["discountPercentage"]?.toDouble(),
        discountedPrice: json["discountedPrice"],
        thumbnail: json["thumbnail"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "quantity": quantity,
        "total": total,
        "discountPercentage": discountPercentage,
        "discountedPrice": discountedPrice,
        "thumbnail": thumbnail,
    };
}
