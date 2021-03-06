import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  String text;
  Offset endpointOffset;
  Function() move;

  Cell({this.text, this.endpointOffset, this.move});

  @override
  State<Cell> createState() => CellState();
}

class CellState extends State<Cell> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation<Offset> offset =
        Tween<Offset>(begin: Offset.zero, end: widget.endpointOffset)
            .animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.move();
      }
    });
    controller.forward();

    return SlideTransition(position: offset, child: Text(widget.text));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
