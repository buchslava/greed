import 'package:flutter/material.dart';

class CellItem {
  int value, prevValue;
  int order;
  bool selected = false;
  Offset position;
  CellItem({this.value, this.order, this.selected}) {}

  saveState() {
    prevValue = value;
  }

  CellItem clone() {
    var res = CellItem(value: this.value, order: this.order, selected: false);
    res.position = Offset(this.position.dx, this.position.dy);
    res.prevValue = this.prevValue;
    return res;
  }
}
