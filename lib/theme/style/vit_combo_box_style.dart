import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/theme/style/combo_box_style.dart';
import 'package:vit_combo_box/theme/style/options_style.dart';

/// The class used to decorate the combobox.
class VitComboBoxStyle {
  /// The style of the label.
  final TextStyle? label;

  /// The style of the options overlay.
  final OptionsStyle? options;

  /// The style of the combo box widget.
  final ComboBoxStyle? comboBox;

  /// Used to calculate the options overlay position.
  ///
  /// This is useful if the widget tree can multiple MaterialApp widgets.
  /// In that case, the position is not calculated correctly by itself.
  ///
  /// One option, could be to get the RenderBox of Scaffold:
  /// ```dart
  /// var parent = Scaffold.of(context).context.findRenderObject() as RenderBox;
  /// ```
  final RenderBox? Function(BuildContext context)? parentRenderBoxGetter;

  /// Creates a instance of a class used to decorate the combobox component.
  VitComboBoxStyle({
    this.comboBox,
    this.label,
    this.options,
    this.parentRenderBoxGetter,
  });
}
