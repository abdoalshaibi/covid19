
import 'package:covid19/model/Counties.dart';
import 'package:covid19/network/Api.dart';
import 'package:covid19/searchPage.dart';
import 'package:covid19/widgets/countriesData.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CountriesCases extends StatefulWidget {
  @override
  _CountriesCasesState createState() => _CountriesCasesState();
}

class _CountriesCasesState extends State<CountriesCases> {
  final controller = ScrollController();
  double offset = 0;
  var api = Api();

  Future<List<Counties>> countryData;
  @override
  void initState() {
    countryData = api.fetchCountriesStats();
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: Search(countryData));
                })
          ],
          title: Text('Country Stats')),
      body: countryData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  MyHeader(
                    image: "assets/icons/Drcorona.svg",
                    textTop: "All you need",
                    textBottom: "is stay at home.",
                    offset: offset,
                  ),
                  Container(
                    child: CountriesData(countryData),
                  )
                ],
              ),
            ),
    );
  }
}
