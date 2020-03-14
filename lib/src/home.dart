import 'dart:async';
import 'dart:math';
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

final _random = new Random();
int random(int min, int max) => min + _random.nextInt(max - min);

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class Item {
  int value, prevValue;
  int order;
  bool selected = false;
  Offset position;
  Item({this.value, this.order, this.selected}) {}

  saveState() {
    prevValue = value;
  }
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  List<Item> model;
  Item selected, playerModel, endpoint;
  Cell player;
  Size _size;
  Offset _pos;
  Timer gameTimer;
  var valuesPool = [5, 10, 15, 20, 25, 30, 35, 40];
  int score;

  bool isOver() {
    for (var i = 0; i < model.length; i++) {
      if (model[i].value == 0) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  start() {
    score = 0;
    model = [];
    for (var i = 0; i < 9; i++) {
      model.add(new Item(value: 0, order: i));
    }
    gameTimer = new Timer.periodic(new Duration(milliseconds: 3000), (timer) {
      if (isOver()) {
        setState(() {
          gameTimer.cancel();
          gameTimer = null;
        });
        return;
      }
      List<int> freeSlots = [];
      for (var i = 0; i < model.length; i++) {
        if (model[i].value == 0) {
          freeSlots.add(i);
        }
      }
      int pos = freeSlots.length == 1 ? 0 : random(0, freeSlots.length - 1);
      int r = random(0, valuesPool.length - 1);

      setState(() {
        model[freeSlots[pos]].value = valuesPool[r];
      });
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
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

  selections(int newOrder, Size s, Offset o) {
    if (isOver()) {
      return;
    }
    _size = s;
    _pos = o;
    Offset pos = _getPos(newOrder);
    double xx = s.width * pos.dx;
    double yy = s.height * pos.dy;

    var current = getCurrent(newOrder);
    current.position = Offset(xx, yy);

    selected = getSelected();

    if (selected != null &&
        (selected.order == newOrder || current.value < selected.value)) {
      setState(() {
        selected.selected = false;
      });
      return;
    }

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
        model[selected.order].saveState(); 
        model[selected.order].value = 0;
      });
    }
  }

  move() {
    if (isOver()) {
      return;
    }
    setState(() {
      for (int i = 0; i < model.length; i++) {
        model[i].selected = false;
      }
      model[endpoint.order].value -= selected.prevValue;
      score += model[selected.order].value;
      model[selected.order].value = 0;
      selected = null;
      playerModel = null;
      player = null;
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
        if (player == null) {
          player = new Cell(
              text: "${playerModel.prevValue}",
              endpointOffset: endpointOffset,
              move: move);
        }
        ch.add(Positioned(
          child: player,
          top: playerModel.position.dy,
          left: playerModel.position.dx,
          width: _size.width,
          height: _size.height,
        ));
      }
      /*
      new Expanded(
            flex: 1,
            child: new Container(
                width: _screenSize.width,
                height: _screenSize.height,
                color: Colors.white,
                child: Stack(children: ch)),
          )
      */
      var sb = RaisedButton(
        child: Text("NEW GAME"),
        onPressed: start,
        color: Colors.green,
        textColor: Colors.yellow,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        splashColor: Colors.grey,
      );
      var sc = Text("$score", style: TextStyle(fontSize: 30));

      return Column(
        children: [
          Container(
            margin: EdgeInsets.all(30.0),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(),
            ),
            child: gameTimer == null ? sb : sc,
          ),
          new Container(
              width: _screenSize.width,
              height: _screenSize.height - 300,
              color: Colors.white,
              child: Stack(children: ch))
        ],
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
