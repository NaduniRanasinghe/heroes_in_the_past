
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:stories_of_heroes/Authentication/authentication.dart';

import '../main.dart';
void main(){

  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds:  new HeroApp(),

        image: Image.network(
              'https://pngimage.net/wp-content/uploads/2018/06/h-logo-png-3.png',
            ),
        backgroundColor: Colors.orange,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: ()=>print("Hero's aplash"),
        loaderColor: Colors.white
    );
  }
}

