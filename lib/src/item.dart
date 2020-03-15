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
}
