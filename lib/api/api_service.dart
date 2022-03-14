import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:versa_flutter_test/models/brewery_model.dart';

class ApiService {
  String apiBaseUrl = 'https://api.openbrewerydb.org/breweries';
  Future<List<BreweryModel>?> getBreweryList({int? page = 1}) async {
    try {
      var url = Uri.parse('$apiBaseUrl?page=$page');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<BreweryModel> breweryModelList = (jsonResponse as List).map((e) => BreweryModel.fromJson(e)).toList();
        return breweryModelList;
      }
    } catch (e) {
      debugPrint('Get Brewery List Error: $e');
    }
    return null;
  }
}
