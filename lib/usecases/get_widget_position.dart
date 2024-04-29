import 'package:flutter/widgets.dart';

/// Gets the position of a widget on the screen.
///
/// For some reason, using the [context] generates a position that is at a
/// offset compared to the real position.
Offset getWidgetPosition({
  GlobalKey? key,
  BuildContext? context,
  RenderObject? parent,
}) {
  BuildContext ctx = context ?? key!.currentContext!;
  var renderBox = ctx.findRenderObject() as RenderBox;
  return renderBox.localToGlobal(Offset.zero, ancestor: parent);
}
