import 'package:flutter/material.dart';
import 'package:greed/src/item.dart';

class Cell2 extends StatefulWidget {
  Item item;
  Function(int current, Size, Offset) selections;

  Cell2({this.item, this.selections});

  @override
  State<Cell2> createState() => CellState2();
}

class CellState2 extends State<Cell2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        final RenderBox box = context.findRenderObject();
        final position = box.localToGlobal(Offset.zero);
        widget.selections(widget.item.order, box.size, position);
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
