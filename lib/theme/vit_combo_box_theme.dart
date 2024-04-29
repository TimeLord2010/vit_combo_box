import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/theme/style/index.dart';

/// A class that holds the logic to insert [VitComboBoxThemeData] into the
/// widget tree as well as getting it using a [BuildContext].
class VitComboBoxTheme extends StatelessWidget {
  /// Creates a instance of the class that holds the logic to insert
  /// [VitComboBoxThemeData] into the widget tree as well as getting it using
  /// a [BuildContext].
  const VitComboBoxTheme({
    super.key,
    required this.child,
    required this.data,
  });

  /// The data of the theme.
  final VitComboBoxStyle data;

  /// Any widget
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  /// Gets the [VitComboBoxThemeData] from the [BuildContext] if any.
  static VitComboBoxStyle? maybeOf(BuildContext context) {
    var child = context.findAncestorWidgetOfExactType<VitComboBoxTheme>();
    return child?.data;
  }

  /// Gets the [VitComboBoxThemeData] from the [BuildContext].
  /// This method throws an exception if no data is found.
  static VitComboBoxStyle of(BuildContext context) {
    var data = maybeOf(context);
    if (data == null) {
      throw StateError('No VitComboBoxThemeData found on context');
    }
    return data;
  }
}
