import 'package:flutter/material.dart';

class Item {
  int value, prevValue;
  int order;
  bool selected = false;
  Offset position;
  Item({this.value, this.order, this.selected}) {}

  saveState() {
    prevValue = value;
  }

  Item clone() {
    var res = Item(value: this.value, order: this.order, selected: false);
    res.position = Offset(this.position.dx, this.position.dy);
    res.prevValue = this.prevValue;
    return res;
  }
}
