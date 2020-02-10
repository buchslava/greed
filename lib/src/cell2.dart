import 'package:flutter/material.dart';

class Cell2 extends StatefulWidget {
  String text;
  Function(Size, Offset) callback;

  Cell2({Key key, this.text, this.callback}) : super(key: key);

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
        widget.callback(box.size, position);
        // setState(() {});
      },
      child: Card(
        child: Text(widget.text),
      ),
    );
  }
}
