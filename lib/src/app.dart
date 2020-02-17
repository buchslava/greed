import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Greed",
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: Text("Greed"),
            centerTitle: true,
          ),
          body: SafeArea(child: new Column(children: [Home()])),
        ));
  }
}
