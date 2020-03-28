import 'package:flutter/material.dart';
import 'package:greed/src/cell-item.dart';

class BoardCell extends StatefulWidget {
  CellItem item;
  Function(int current, Size) selections;

  BoardCell({this.item, this.selections});

  @override
  State<BoardCell> createState() => CellState2();
}

class CellState2 extends State<BoardCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        final RenderBox box = context.findRenderObject();
        widget.selections(widget.item.order, box.size);
      },
      child: Card(
        color: (widget.item.selected == true ? Colors.yellow : Colors.white),
        child: Center(
          child: Text(
            widget.item.value == 0 ? '' : widget.item.value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 45.0,
                color:
                    (widget.item.selected == true ? Colors.red : Colors.black)),
          ),
        ),
      ),
    );
  }
}
