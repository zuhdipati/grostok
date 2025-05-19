class CartModel {
  int id;
  int totalQuantity;
  String image;
  String name;
  String category;
  String brand;
  double price;

  CartModel({
    required this.id,
    required this.totalQuantity,
    required this.image,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        totalQuantity: json["totalQuantity"],
        image: json["image"],
        name: json["name"],
        category: json["category"],
        brand: json["brand"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalQuantity": totalQuantity,
        "image": image,
        "name": name,
        "category": category,
        "brand": brand,
        "price": price,
      };
}
