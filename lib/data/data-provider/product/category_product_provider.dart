import 'dart:convert';
import 'dart:developer';

import 'package:grostok/core/const/endpoint.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class CategoryProductProvider {
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

      List<String> body = List<String>.from(jsonDecode(response.body));

      return {
        "error": false,
        "message": "OK",
        "data": body,
      };
    } catch (e) {
      log("$e");
      return {
        "error": true,
        "message": "$e",
      };
    }
  }

  Future<Map<String, dynamic>> getProductByCategory(String name, String limit, String skip) async {
    try {
      Uri url = Uri.parse(urlGetProductByCategory(name, limit, skip));
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
        "data": ProductModel.fromJson(body),
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
