import 'package:covid19/CountriesCases.dart';
import 'package:covid19/info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Covid19banner.png"),
                  fit: BoxFit.fill),
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("PREVENTION & SYMPTOMS"),
            leading: Icon(Icons.offline_pin),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return InfoScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text("Countries Cases"),
            leading: Icon(Icons.flag),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CountriesCases();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
