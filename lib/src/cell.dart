import 'package:flutter/material.dart';

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
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    offset = Tween<Offset>(
            begin: Offset(widget.x, widget.y),
            end: Offset(1.0 + widget.x, 1.0 + widget.y))
        .animate(controller);
  }

  go() {
    switch (controller.status) {
      case AnimationStatus.completed:
        controller.reverse();
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SlideTransition(
        position: offset,
        child: Text(widget.text, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
