import 'package:flutter/material.dart';
import 'package:greed/src/cell.dart';
import 'package:greed/src/cell2.dart';

final key1 = new GlobalKey<CellState2>();
final key2 = new GlobalKey<CellState2>();
final key3 = new GlobalKey<CellState2>();
final key4 = new GlobalKey<CellState2>();
final key5 = new GlobalKey<CellState2>();
final key6 = new GlobalKey<CellState2>();
final key7 = new GlobalKey<CellState2>();
final key8 = new GlobalKey<CellState2>();
final key9 = new GlobalKey<CellState2>();
final key10 = new GlobalKey<CellState>();

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  List<Cell2> cells2;
  Cell player;

  @override
  void initState() {
    super.initState();
    cells2 = [
      new Cell2(key: key1, text: "c1", callback: callback),
      new Cell2(key: key2, text: "c2", callback: callback),
      new Cell2(key: key3, text: "c3", callback: callback),
      new Cell2(key: key4, text: "c4", callback: callback),
      new Cell2(key: key5, text: "c5", callback: callback),
      new Cell2(key: key6, text: "c6", callback: callback),
      new Cell2(key: key7, text: "c7", callback: callback),
      new Cell2(key: key8, text: "c8", callback: callback),
      new Cell2(key: key9, text: "c9", callback: callback),
    ];
    player = new Cell(key: key10, text: "c5");
  }

  callback(Size s, Offset o) {
    print("$s $o");
    setState(() {});
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
            child: Stack(
              children: <Widget>[
                GridView.count(
                  crossAxisCount: 3,
                  children: cells2.map((cell) => cell).toList(),
                ),
                Positioned(
                  child: player,
                  top: 0,
                  left: 0,
                ),
              ],
            )),
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
