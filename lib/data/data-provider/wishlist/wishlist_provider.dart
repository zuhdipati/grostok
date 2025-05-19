import 'dart:convert';
import 'dart:developer';

import 'package:grostok/data/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:grostok/core/const/endpoint.dart';

class WishlistProvider {
  Future<Map<String, dynamic>> getCategoryProduct(int idProduct) async {
    try {
      Uri url = Uri.parse(urlGetSingleProduct(idProduct));
      log("$url");
      var response = await http.get(url);

      if (response.statusCode != 200) {
        return {
          "error": true,
          "message": "${response.statusCode}",
        };
      }

      Map<String, dynamic> body = jsonDecode(response.body);

      return {
        "error": false,
        "message": "OK",
        "data": ProductData.fromJson(body),
      };
    } catch (e) {
      log("$e");
      return {
        "error": true,
        "message": "$e",
      };
    }
  }
}
