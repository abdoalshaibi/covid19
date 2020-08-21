import 'package:covid19/model/Counties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'counter.dart';

Widget CountriesData(Future<List<Counties>> list) {
  return FutureBuilder<List<Counties>>(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.only(bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white),
                        child: Column(children: [
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              snapshot.data[i].country,
                              style: kHeadingTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            spacing: 25.0,
                            children: [
                              Counter(
                                  number: snapshot.data[i].cases,
                                  title: "CONFIRMED",
                                  color: Colors.amber),
                              Counter(
                                  number: snapshot.data[i].active,
                                  title: "ACTIVE",
                                  color: kInfectedColor),
                              Counter(
                                  number: snapshot.data[i].recovered,
                                  title: "RECOVERED",
                                  color: kRecovercolor),
                              Counter(
                                  number: snapshot.data[i].deaths,
                                  title: "DEATHS",
                                  color: kDeathColor)
                            ],
                          )
                        ]),
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width / 2 - 30,
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data[i].countryInfo.flag,
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return Center(child: CircularProgressIndicator());
    },future: list,
  );
}
