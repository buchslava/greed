import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:greed/src/player-cell.dart';
import 'package:greed/src/board-cell.dart';
import 'package:greed/src/cell-item.dart';

final _random = new Random();
int random(int min, int max) => min + _random.nextInt(max - min);

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool _measured = false;
  Size _screenSize;
  List<CellItem> model;
  CellItem selected;
  List<PlayerCell> players = [];
  Size _size;
  Timer gameTimer;
  int score;
  int globalId = 1;
  var valuesPool = [5, 10, 15, 20, 25, 30, 35, 40];

  @override
  void initState() {
    super.initState();
    _start();
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
          children: model.map((CellItem item) {
            return new BoardCell(item: item, selections: selections);
          }).toList(),
        ),
      ];
      if (players.length > 0) {
        for (var i = 0; i < players.length; i++) {
          ch.add(Positioned(
            child: players[i],
            top: players[i].model.position.dy,
            left: players[i].model.position.dx,
            width: _size.width,
            height: _size.height,
          ));
        }
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
        onPressed: _start,
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

  selections(int newOrder, Size s) {
    if (_isOver()) {
      return;
    }
    _size = s;
    Offset pos = _getPos(newOrder);
    double xx = s.width * pos.dx;
    double yy = s.height * pos.dy;

    var current = _getCurrent(newOrder);
    current.position = Offset(xx, yy);

    selected = _getSelected();

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
          model[i].selected = model[i] == current && model[i].value > 0;
        }
      });
    } else {
      setState(() {
        CellItem endpoint = current;
        selected.saveState();
        selected.value = 0;
        var selectedPos = _getPos(selected.order);
        var endpointPos = _getPos(endpoint.order);
        var endpointOffset = Offset(
            endpointPos.dx - selectedPos.dx, endpointPos.dy - selectedPos.dy);
        players.add(new PlayerCell(
            id: globalId++,
            model: selected.clone(),
            target: endpoint.clone(),
            endpointOffset: endpointOffset,
            move: _move));
      });
    }
  }

  _move(int id) {
    if (_isOver()) {
      return;
    }
    setState(() {
      for (int i = 0; i < model.length; i++) {
        model[i].selected = false;
      }
      var relatedPlayer =
          players.singleWhere((p) => p.id == id, orElse: () => null);
      if (relatedPlayer != null) {
        model[relatedPlayer.target.order].value -=
            relatedPlayer.model.prevValue;
        score += relatedPlayer.model.prevValue;
        selected = null;
        players.removeWhere((p) => p.id == id);
      }
    });
  }

  CellItem _getCurrent(int order) {
    for (int i = 0; i < model.length; i++) {
      if (model[i].order == order) {
        return model[i];
      }
    }
    return null;
  }

  CellItem _getSelected() {
    for (int i = 0; i < model.length; i++) {
      if (model[i].selected == true) {
        return model[i];
      }
    }
    return null;
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

  _start() {
    score = 0;
    model = [];
    for (var i = 0; i < 9; i++) {
      model.add(new CellItem(value: 0, order: i));
    }
    gameTimer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      if (_isOver()) {
        if (gameTimer != null && gameTimer.isActive) {
          gameTimer.cancel();
          gameTimer = null;
        }
        setState(() {});
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

  _measure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.of(context).size;
      setState(() {
        _measured = true;
      });
    });
  }

  bool _isOver() {
    for (var i = 0; i < model.length; i++) {
      if (model[i].value == 0) {
        return false;
      }
    }
    return true;
  }
}
