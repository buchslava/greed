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
    Animation<Offset> offset =
        Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 1.0))
            .animate(controller);

    return SlideTransition(
      position: offset,
      child: new GestureDetector(
        onTap: () {
          // restore new card after animation end
          // elevation - global keys
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
        child: Card(
          child: Text(widget.text),
          elevation: 8,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
