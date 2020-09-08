import 'package:flutter/material.dart';
import 'package:houseprediction/Navbar/Navbar.dart';

import 'LandingPage/LandingPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            accentColor: Colors.white,
           fontFamily: "Montserrat"),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children:[
          Image.asset('assets/two.jpeg',fit: BoxFit.cover,
            color: Color(0xff003333).withOpacity(0.7),
            colorBlendMode: BlendMode.darken,),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Navbar(),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 40.0),
                    child: LandingPage(),
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}