import 'dart:convert';
import 'dart:developer';
import 'package:grostok/core/const/endpoint.dart';
import 'package:grostok/data/models/add_checkout_model.dart';
import 'package:http/http.dart' as http;

class CheckoutDataProvider {

  CheckoutDataProvider();

  Future<Map<String, dynamic>> addToCheckout(AddToCheckoutRequestModel model) async {
    try {
      final url = Uri.parse(urlAddCart);
      log("$url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode != 201) {
        return {
          "error": true,
          "message": "${response.statusCode}",
        };
      }

      Map<String, dynamic> body = jsonDecode(response.body);

      return {
        "error": false,
        "message": "OK",
        "data": body
      };
    } catch (e) {
      return {
        "error": true,
        "message": "$e",
      };
    }
  }
}
