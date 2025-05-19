import 'dart:convert';
import 'dart:developer';

import 'package:grostok/core/const/endpoint.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductProvider {
  Future<Map<String, dynamic>> getProduct(String limit, String skip) async {
    try {
      Uri url = Uri.parse(urlGetProduct(limit, skip));
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
        "data": ProductModel.fromJson(body)
      };
    } catch (e) {
      return {
        "error": true,
        "message": "$e",
      };
    }
  }

  Future<Map<String, dynamic>> getCategoryProduct() async {
    try {
      Uri url = Uri.parse(urlGetCategoryProduct);
      log("$url");
      var response = await http.get(url);

      if (response.statusCode != 200) {
        return {
          "error": true,
          "message": "${response.statusCode}",
        };
      }

      Map<String, dynamic> body = jsonDecode(response.body);

      return {"error": false, "message": "OK", "data": body};
    } catch (e) {
      return {
        "error": true,
        "message": "$e",
      };
    }
  }
}
