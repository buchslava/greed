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

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  List<Cell2> cells2;
  Cell player;
  Size _size;
  Offset _pos;

  @override
  void initState() {
    super.initState();
    cells2 = [
      new Cell2(key: key1, text: "c1", callback: callback, order: 0),
      new Cell2(key: key2, text: "c2", callback: callback, order: 1),
      new Cell2(key: key3, text: "c3", callback: callback, order: 2),
      new Cell2(key: key4, text: "c4", callback: callback, order: 3),
      new Cell2(key: key5, text: "c5", callback: callback, order: 4),
      new Cell2(key: key6, text: "c6", callback: callback, order: 5),
      new Cell2(key: key7, text: "c7", callback: callback, order: 6),
      new Cell2(key: key8, text: "c8", callback: callback, order: 7),
      new Cell2(key: key9, text: "c9", callback: callback, order: 8),
    ];
  }

  Offset _getPos(int order) {
    int p = 0;
    for (int y = 0;; y++) {
      for (int x = 0; x < 3; x++) {
        if (p++ == order) {
          return Offset(x.toDouble(), y.toDouble());
        }
      }
    }
  }

  callback(int order, Size s, Offset o, GlobalKey<CellState2> key) {
    _size = s;
    _pos = o;

    Offset pos = _getPos(order);
    double xx = s.width * pos.dx;
    double yy = s.height * pos.dy;
    print("$xx $yy");
    _pos = Offset(xx, yy);
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
      player = new Cell(text: "player");

      var ch = <Widget>[
        GridView.count(
          crossAxisCount: 3,
          children: cells2.toList(),
        ),
      ];
      if (_pos != null && _size != null) {
        ch.add(Positioned(
          child: player,
          top: _pos.dy,
          left: _pos.dx,
          width: _size.width,
          height: _size.height,
        ));
      }
      return new Expanded(
        flex: 1,
        child: new Container(
            width: _screenSize.width,
            height: _screenSize.height,
            color: Colors.white,
            child: Stack(children: ch)),
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
