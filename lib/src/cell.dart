import 'dart:math';
import 'package:flutter/material.dart';

var rng = new Random();

class Cell extends StatefulWidget {
  double x;
  double y;
  String text;

  Cell({Key key, this.x, this.y, this.text}) : super(key: key);

  @override
  State<Cell> createState() => CellState();
}

class CellState extends State<Cell> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> offset;

    var o1 = rng.nextDouble() * 2.0 + 3.0;
    var o2 = rng.nextDouble() * 2.0 + 3.0;
    offset = Tween<Offset>(
            begin: Offset(widget.x, widget.y),
            end: Offset(o1 + widget.x, o2 + widget.y))
        .animate(controller);

    return SlideTransition(
      position: offset,
      child: new GestureDetector(
          onTap: () {
            print(widget.text);
            switch (controller.status) {
              case AnimationStatus.completed:
                controller.reverse();
                break;
              case AnimationStatus.dismissed:
                controller.forward();
                break;
              default:
            }
            setState(() {});
          },
          child: new Text(widget.text)),
    );
  }
}
