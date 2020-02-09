import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  String text;

  Cell({Key key, this.text}) : super(key: key);

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
          final RenderBox box = context.findRenderObject();
          final position = box.localToGlobal(Offset.zero);
          print("${box.size} $position");
          // todo restore new card after animation end
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
