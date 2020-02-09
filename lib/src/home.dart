import 'package:flutter/material.dart';
import 'package:greed/src/cell.dart';

final key1 = new GlobalKey<CellState>();
final key2 = new GlobalKey<CellState>();
final key3 = new GlobalKey<CellState>();
final key4 = new GlobalKey<CellState>();
final key5 = new GlobalKey<CellState>();
final key6 = new GlobalKey<CellState>();
final key7 = new GlobalKey<CellState>();
final key8 = new GlobalKey<CellState>();
final key9 = new GlobalKey<CellState>();

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  List<Cell> cells = [
    new Cell(key: key1, x: 0.0, y: 0.0, text: "c1"),
    new Cell(key: key2, x: 1.0, y: 0.0, text: "c2"),
    new Cell(key: key3, x: 2.0, y: 0.0, text: "c3"),
    new Cell(key: key4, x: 0.0, y: 1.0, text: "c4"),
    new Cell(key: key5, x: 1.0, y: 1.0, text: "c5"),
    new Cell(key: key6, x: 2.0, y: 1.0, text: "c6"),
    new Cell(key: key7, x: 0.0, y: 2.0, text: "c7"),
    new Cell(key: key8, x: 1.0, y: 2.0, text: "c8"),
    new Cell(key: key9, x: 2.0, y: 2.0, text: "c9"),
  ];

  @override
  void initState() {
    super.initState();
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
          child: GridView.count(
            crossAxisCount: 3,
            children: cells.map((cell) => cell).toList(),
          ),
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
