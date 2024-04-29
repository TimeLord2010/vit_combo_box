import 'package:flutter/widgets.dart';

class OptionsStyle {
  /// The height of the options container displayed when the user selects the
  /// widget.
  final double? containerHeight;

  /// The padding applied to the options container.
  final EdgeInsets? padding;

  /// The offset used to adjust the position of the options overlay.
  ///
  /// In case the options container is being displayed too far-off, the cause
  /// if likely the use of multiple MaterialApp or Scaffold in the widget tree.
  /// If so, use [decorationBuilder] instead.
  final Offset? offset;

  /// The decoration of the overlay container displayed onTap.
  ///
  /// This is a callback because the method is called for every frame of the
  /// animation.
  final BoxDecoration Function(double height)? decorationBuilder;

  OptionsStyle({
    this.containerHeight,
    this.padding,
    this.offset,
    this.decorationBuilder,
  });
}
