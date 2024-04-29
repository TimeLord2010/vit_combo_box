import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/theme/style/vit_combo_box_style.dart';

class VitComboBoxThemeData {
  final RenderBox? Function(BuildContext context)? parentRenderBoxGetter;
  final VitComboBoxStyle? style;

  VitComboBoxThemeData({
    this.parentRenderBoxGetter,
    this.style,
  });
}
