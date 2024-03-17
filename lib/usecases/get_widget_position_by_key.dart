import 'package:flutter/widgets.dart';

Offset getWidgetPosition(GlobalKey key) {
  final renderBox = key.currentContext?.findRenderObject() as RenderBox;
  return renderBox.localToGlobal(Offset.zero);
}
