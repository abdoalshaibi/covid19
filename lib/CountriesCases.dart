import 'package:covid19/model/Counties.dart';
import 'package:covid19/network/Api.dart';
import 'package:covid19/searchPage.dart';
import 'package:covid19/widgets/Drawer.dart';
import 'package:covid19/widgets/countriesData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

import 'constant.dart';

class CountriesCases extends StatefulWidget {
  @override
  _CountriesCasesState createState() => _CountriesCasesState();
}

class _CountriesCasesState extends State<CountriesCases> {
  final controller = ScrollController();
  double offset = 0;
  var api = Api();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: countryData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.only(left: 40, top: 50, right: 20),
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(18.0),
                              bottomRight: Radius.circular(18.0)),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF3383CD),
                              Color(0xFF11249F),
                            ],
                          ),
                          image: DecorationImage(
                            image: AssetImage("assets/images/virus.png"),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showSearch(
                                            context: context,
                                            delegate: Search(countryData));
                                      },
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _scaffoldKey.currentState.openDrawer();
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons/menu.svg"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: (offset < 0) ? 0 : offset,
                                    child: SvgPicture.asset(
                                      "",
                                      width: 230,
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  Positioned(
                                    top: 20 - offset / 2,
                                    left: 150,
                                    child: Text(
                                      " \n",
                                      style: kHeadingTextStyle.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(), // I dont know why it can't work without container
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<List<Counties>>(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                    return SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                        return CountriesData(
                            snapshot.data[i].country,
                            snapshot.data[i].cases,
                            snapshot.data[i].active,
                            snapshot.data[i].recovered,
                            snapshot.data[i].deaths,
                            snapshot.data[i].countryInfo.flag,
                            context);
                      }, childCount: snapshot.data.length));

                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return SliverToBoxAdapter(child: CircularProgressIndicator(),);
                  },
                  future: countryData,
                ),
              ],
            ),
    );
  }
}
