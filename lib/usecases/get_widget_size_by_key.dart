import 'package:flutter/widgets.dart';

/// Gets the size of the widget on the screen.
Size getWidgetSize(GlobalKey key) {
  var renderBox = key.currentContext?.findRenderObject() as RenderBox;
  return renderBox.size;
}
