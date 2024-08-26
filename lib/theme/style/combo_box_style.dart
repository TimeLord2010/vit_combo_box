import 'package:flutter/widgets.dart';

/// The style used by the combobox component.
class ComboBoxStyle {
  /// The decoration for the container of the widget
  final BoxDecoration? decoration;

  /// The height of the widget.
  final double? height;

  /// The padding applied to the combo box container.
  final EdgeInsets? padding;

  /// Creates a combobox style instance.
  ComboBoxStyle({
    this.decoration,
    this.height,
    this.padding,
  });
}
