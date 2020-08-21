import 'dart:developer';

import 'package:covid19/constant.dart';
import 'package:covid19/model/Counties.dart';
import 'package:covid19/widgets/countriesData.dart';
import 'package:flutter/material.dart';
import 'package:covid19/widgets/counter.dart';

class Search extends SearchDelegate {
  Future<List<Counties>> countryList;
  final controller = ScrollController();
  double offset = 0;
  Search(this.countryList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Future<List<Counties>> parseCountries(Future<List<Counties>> list) {
    return list.then((value) => value
        .where((element) =>
            element.country.toLowerCase().startsWith(query.toLowerCase()))
        .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        query.isEmpty ? countryList : parseCountries(countryList);

    return CountriesData(suggestionList);
  }
}
