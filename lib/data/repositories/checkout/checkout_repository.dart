import 'package:grostok/data/data-provider/checkout/checkout_provider.dart';
import 'package:grostok/data/models/add_checkout_model.dart';

class CheckoutRepository {
  final CheckoutDataProvider dataProvider = CheckoutDataProvider();

  Future<Map<String, dynamic>> addToCheckout(AddToCheckoutRequestModel model) async {
    Map<String, dynamic> dataCart = await dataProvider.addToCheckout(model);

    if (dataCart["error"] == true) {
      return {
        "error": true,
        "message": "error add cart",
      };
    }

    return {
      "error": false,
      "message": "success add cart",
      "data": dataCart['data']
    };
  }
}
