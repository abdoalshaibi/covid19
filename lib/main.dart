import 'package:covid19/constant.dart';
import 'package:covid19/model/Counties.dart';
import 'package:covid19/model/Covid19Stat.dart';
import 'package:covid19/network/Api.dart';
import 'package:covid19/widgets/Drawer.dart';
import 'package:covid19/widgets/MostAffected.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool is_connected = false;

  CheckInternet() async {
    DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          is_connected = true;
          break;
        case DataConnectionStatus.disconnected:
          is_connected = false;
          break;
      }
    });
  }

  @override
  void initState() {
    CheckInternet();
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
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "All you need",
              textBottom: "is stay at home.",
              offset: offset,
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
