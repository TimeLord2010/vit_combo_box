import 'package:flutter/widgets.dart';

Offset getWidgetPosition({
  GlobalKey? key,
  BuildContext? context,
  RenderObject? parent,
}) {
  BuildContext ctx = context ?? key!.currentContext!;
  final renderBox = ctx.findRenderObject() as RenderBox;
  return renderBox.localToGlobal(Offset.zero, ancestor: parent);
}
