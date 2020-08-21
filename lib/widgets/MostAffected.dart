import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MostAffected(String flag, int death) {
  return Padding(
    padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 10.0),
    child: Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0,left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.transparent,
              image: DecorationImage(
                image: NetworkImage(
                  flag,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 50.0,),
          Text("Deaths : $death")
        ],
      ),
    ),
  );
}
