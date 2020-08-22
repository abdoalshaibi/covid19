import 'package:covid19/constant.dart';
import 'package:covid19/model/Counties.dart';
import 'package:covid19/model/Covid19Stat.dart';
import 'package:covid19/network/Api.dart';
import 'package:covid19/widgets/Drawer.dart';
import 'package:covid19/widgets/MostAffected.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;
  var api = Api();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
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
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
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
                    Color(0xFF82B1FF),
                    Color(0xFF2962FF),
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/virus.png"),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                       child: SvgPicture.asset("assets/icons/menu.svg"),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: (offset < 0) ? 0 : offset,
                          child: SvgPicture.asset(
                            "assets/icons/Drcorona.svg",
                            width: 230,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        Positioned(
                          top: 20 - offset / 2,
                          left: 150,
                          child: Text(
                            "Covid 19\nstatistics all the world",
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
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: kTitleTextstyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 25.0,
                      children: [
                        FutureBuilder<Covid19Stats>(
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                spacing: 25.0,
                                children: [
                                  Counter(
                                    color: kInfectedColor,
                                    number: snapshot.data.active,
                                    title: "Infected",
                                  ),
                                  Counter(
                                    color: kDeathColor,
                                    number: snapshot.data.deaths,
                                    title: "Deaths",
                                  ),
                                  Counter(
                                    color: kRecovercolor,
                                    number: snapshot.data.recovered,
                                    title: "Recovered",
                                  )
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return CircularProgressIndicator();
                          },
                          future: api.fetchWorldStats(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Most Affected Countries",
                    style: kTitleTextstyle,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      padding: EdgeInsets.all(20),
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ],
                      ),
                      child: FutureBuilder<List<Counties>>(
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    MostAffected(
                                        snapshot.data[i].countryInfo.flag,
                                        snapshot.data[i].deaths),
                                  ],
                                );
                              },
                              itemCount: 4,
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.hasError}");
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        future: api.fetchCountriesStats(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
