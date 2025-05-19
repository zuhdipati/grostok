class ProductItem {
  final int id;
  final int quantity;

  ProductItem({required this.id, required this.quantity});

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}

class AddToCheckoutRequestModel {
  final int userId;
  final List<ProductItem> products;

  AddToCheckoutRequestModel({required this.userId, required this.products});

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "products": products.map((e) => e.toJson()).toList(),
      };
}
