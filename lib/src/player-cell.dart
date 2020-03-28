import 'package:flutter/material.dart';
import 'package:greed/src/cell-item.dart';

class PlayerCell extends StatefulWidget {
  int id;
  CellItem model, target;
  Offset endpointOffset;
  Function(int id) move;

  PlayerCell(
      {this.id, this.model, this.target, this.endpointOffset, this.move});

  @override
  State<PlayerCell> createState() => PlayerCellState();
}

class PlayerCellState extends State<PlayerCell> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    Animation<Offset> offset =
        Tween<Offset>(begin: Offset.zero, end: widget.endpointOffset)
            .animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.move(widget.id);
      }
    });
    controller.forward();

    return SlideTransition(
        position: offset,
        child: Card(
            child: Center(
                child: Text("${widget.model.prevValue}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 45.0,
                      color: Colors.green,
                    )))));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}