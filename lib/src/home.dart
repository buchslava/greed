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

class Item {
  int value;
  int order;
  bool selected = false;
  Offset position;
  Item({this.value, this.order, this.selected}) {}
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  List<Item> model;
  Item selected, playerModel, endpoint;
  Size _size;
  Offset _pos;

  @override
  void initState() {
    super.initState();
    model = [
      new Item(value: 10, order: 0),
      new Item(value: 5, order: 1),
      new Item(value: 15, order: 2),
      new Item(value: 20, order: 3),
      new Item(value: 40, order: 4),
      new Item(value: 25, order: 5),
      new Item(value: 5, order: 6),
      new Item(value: 30, order: 7),
      new Item(value: 45, order: 8),
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

  selections(int currentOrder, Size s, Offset o) {
    _size = s;
    _pos = o;
    Offset pos = _getPos(currentOrder);
    double xx = s.width * pos.dx;
    double yy = s.height * pos.dy;

    var current = getCurrent(currentOrder);
    current.position = Offset(xx, yy);

    selected = getSelected();
    if (selected == null) {
      setState(() {
        for (int i = 0; i < model.length; i++) {
          model[i].selected = model[i] == current;
        }
      });
    } else {
      setState(() {
        endpoint = current;
        playerModel = selected;
      });
    }
  }

  move() {
    setState(() {
      for (int i = 0; i < model.length; i++) {
        model[i].selected = false;
      }
      model[endpoint.order].value -= model[selected.order].value;
      selected = null;
      playerModel = null;
      endpoint = null;
    });
  }

  Item getCurrent(int order) {
    for (int i = 0; i < model.length; i++) {
      if (model[i].order == order) {
        return model[i];
      }
    }
    return null;
  }

  Item getSelected() {
    for (int i = 0; i < model.length; i++) {
      if (model[i].selected == true) {
        return model[i];
      }
    }
    return null;
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
      var ch = <Widget>[
        GridView.count(
          crossAxisCount: 3,
          children: model.map((Item item) {
            return new Cell2(item: item, selections: selections);
          }).toList(),
        ),
      ];
      if (playerModel != null) {
        var selectedPos = _getPos(selected.order);
        var endpointPos = _getPos(endpoint.order);
        var endpointOffset = Offset(
            endpointPos.dx - selectedPos.dx, endpointPos.dy - selectedPos.dy);
        ch.add(Positioned(
          child: new Cell(
              text: "${playerModel.value}",
              endpointOffset: endpointOffset,
              move: move),
          top: playerModel.position.dy,
          left: playerModel.position.dx,
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
