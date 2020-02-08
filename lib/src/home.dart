import 'package:flutter/material.dart';
import 'package:greed/src/cell.dart';

final key1 = new GlobalKey<CellState>();
final key2 = new GlobalKey<CellState>();
final key3 = new GlobalKey<CellState>();

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  Cell c1, c2, c3;

  @override
  void initState() {
    super.initState();

    c1 = new Cell(key: key1, x: 0.0, y: 0.0, text: "0");
    c2 = new Cell(key: key2, x: 3.0, y: 3.0, text: "1");
    c3 = new Cell(key: key3, x: 6.0, y: 0.0, text: "2");
  }

  @override
  Widget build(BuildContext context) {
    if (!_measured) {
      _measure();
      return new Expanded(
        child: new Container(
          color: Colors.white,
        ),
      );
    } else {
      return new Expanded(
        flex: 1,
        child: new Container(
          width: _screenSize.width,
          height: _screenSize.height,
          color: Colors.white,
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                c1,
                c2,
                c3,
              ]),
        ),
      );
    }
  }

  _measure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.of(context).size;
      setState(() {
        _measured = true;
      });
    });
  }
}
