
import 'dart:convert';
import 'package:covid19/model/Counties.dart';
import 'package:http/http.dart';
import 'package:covid19/model/Covid19Stat.dart';

class Api
{
  Future<Covid19Stats> fetchWorldStats() async {
    final response = await get('https://corona.lmao.ninja/v2/all');
    if (response.statusCode == 200) {
      return Covid19Stats.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  List<Counties> parseCountries(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Counties>((json) => Counties.fromJson(json)).toList();
  }

  Future<List<Counties>> fetchCountriesStats() async {
    final response =
    await get('https://corona.lmao.ninja/v2/countries?sort=cases');
    if (response.statusCode == 200) {
      return parseCountries(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}