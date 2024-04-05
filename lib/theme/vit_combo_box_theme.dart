import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/theme/vit_combo_box_theme_data.dart';

class VitComboBoxTheme extends StatelessWidget {
  const VitComboBoxTheme({
    super.key,
    required this.child,
    required this.data,
  });

  final VitComboBoxThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  static VitComboBoxThemeData? maybeOf(BuildContext context) {
    var child = context.findAncestorWidgetOfExactType<VitComboBoxTheme>();
    return child?.data;
  }

  static VitComboBoxThemeData of(BuildContext context) {
    var data = maybeOf(context);
    if (data == null) {
      throw StateError('No VitComboBoxThemeData found on context');
    }
    return data;
  }
}
