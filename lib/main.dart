import 'package:flutter/material.dart';
import 'package:stories_of_heroes/Authentication/registration.dart';

import 'package:stories_of_heroes/Heroes/homepage.dart';
import 'package:stories_of_heroes/Other/mappping.dart';
import 'package:stories_of_heroes/Authentication/authentication.dart';

import 'Other/splash.dart';


void main()
{
  runApp(HeroApp());
}


class HeroApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp
      (
      title: "Heroes",

      theme: ThemeData
        (
        primarySwatch: Colors.orange

        ),

      home: Mapping(auth: Auth(),), //setting up the home page

      );
  }

}