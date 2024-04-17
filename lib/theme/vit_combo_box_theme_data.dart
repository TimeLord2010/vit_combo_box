import 'package:flutter/widgets.dart';

class VitComboBoxThemeData {
  final RenderBox? Function(BuildContext context)? parentRenderBoxGetter;
  final BoxDecoration? decoration;
  final TextStyle? labelStyle;

  VitComboBoxThemeData({
    this.parentRenderBoxGetter,
    this.decoration,
    this.labelStyle,
  });
}
