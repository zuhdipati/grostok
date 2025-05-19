import 'dart:convert';
import 'dart:developer';

import 'package:grostok/core/const/endpoint.dart';
import 'package:grostok/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class SearchProductProvider {
  Future<Map<String, dynamic>> searchProduct(
      String query, String limit, String skip) async {
    try {
      Uri url = Uri.parse(urlSearchProduct(query, limit, skip));
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
}
