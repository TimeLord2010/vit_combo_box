import 'package:flutter/widgets.dart';

class VitComboBoxThemeData {
  final RenderBox? Function(BuildContext context)? parentRenderBoxGetter;
  final BoxDecoration? decoration;

  VitComboBoxThemeData({
    this.parentRenderBoxGetter,
    this.decoration,
  });
}
