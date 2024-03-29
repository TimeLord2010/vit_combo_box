import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/vit_asset_icon.dart';
import 'package:vit_combo_box/components/vit_button.dart';
import 'package:vit_combo_box/components/vit_text.dart';
import 'package:vit_combo_box/theme/colors.dart';
import 'package:vit_combo_box/theme/decorations.dart';
import 'package:vit_combo_box/usecases/get_widget_position_by_key.dart';
import 'package:vit_combo_box/usecases/get_widget_size_by_key.dart';

/// A widget similar to a text box, but on tap, a overlay of options is shown
/// below it, allowing the user to choose an option.
class VitComboBox<T> extends StatefulWidget {
  VitComboBox({
    super.key,
    required this.options,
    this.label,
    this.selection,
    this.itemBuilder,
    this.onSelected,
    this.selectedItemBuilder,
    this.decoration,
    this.height,
    this.enabled = true,
    this.optionsBuilder,
    this.onClose,
    this.optionsContainerHeight = 150,
    this.trailing,
    this.labelStyle,
    this.overlayDecorationBuilder,
  }) {
    assert(
      optionsBuilder != null || itemBuilder != null,
      'Either optionsBuilder or itemBuilder must be given',
    );
    assert(
      (optionsBuilder != null && itemBuilder == null) || (itemBuilder != null && optionsBuilder == null),
      'If optionsBuilder is given, then itemBuilder must be null. The same if itemBuilder is given instead',
    );
    assert(
      itemBuilder == null || onSelected != null,
      'If itemBuilder is give, then onSelected must be also given',
    );
  }

  /// The text displayed above it so indicate to the user with field this
  /// component belongs to
  final String? label;

  /// The style of the [label].
  final TextStyle? labelStyle;

  /// The current item selected between [options].
  final T? selection;

  /// The options to display to the user
  final Set<T> options;

  /// The height of the widget.
  final double? height;

  /// The height of the options container displayed when the user selects the
  /// widget.
  final double optionsContainerHeight;

  /// Indicates to the user whether the widget is interactiable or not.
  final bool enabled;

  /// The decoration for the container of the widget
  final BoxDecoration? decoration;

  /// The decoration of the overlay container displayed onTap.
  final BoxDecoration Function(double height)? overlayDecorationBuilder;

  /// Optional parameter to build a custom layout when the widget is selected.
  final Widget Function(Set<T> options)? optionsBuilder;

  /// Optional parameter to build the current selection inside the widget.
  final Widget Function(T? selection)? selectedItemBuilder;

  /// The builder from each item inside options.
  /// If [optionsBuilder] is given, then this parameter must not be provided.
  final Widget Function(T item)? itemBuilder;

  /// The callback invoked when an option is selected.
  /// You can prevent the overlay from closing by returning `false`.
  ///
  /// If [optionsBuilder] is given, then this parameter must not be provided.
  final FutureOr<bool?> Function(T key)? onSelected;

  /// Invoked when the overlay is closed.
  final void Function()? onClose;

  /// The widget shown at the end of the widget.
  final Widget? trailing;

  @override
  State<VitComboBox> createState() => _VitComboBoxState<T>();
}

class _VitComboBoxState<T> extends State<VitComboBox<T>> {
  final GlobalKey _widgetKey = GlobalKey();
  OverlayEntry? entry;

  void onPressed() {
    entry = OverlayEntry(
      builder: (context) {
        var position = getWidgetPosition(_widgetKey);
        var size = getWidgetSize(_widgetKey);

        Widget build() {
          return Stack(
            children: [
              Positioned.fill(
                child: VitButton(
                  onPressed: () {
                    entry?.remove();
                    var onClose = widget.onClose;
                    if (onClose != null) onClose();
                  },
                  child: Container(color: black.withOpacity(0.01)),
                ),
              ),
              Positioned(
                left: position.dx,
                top: position.dy + size.height + 2,
                width: size.width,
                child: _optionsContainer(),
              ),
            ],
          );
        }

        return Material(
          type: MaterialType.transparency,
          child: Builder(
            builder: (context) => build(),
          ),
        );
      },
    );
    Overlay.of(context).insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final enabled = widget.enabled;
    return VitButton(
      onPressed: enabled ? onPressed : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            VitText(
              label,
              style: widget.labelStyle ??
                  TextStyle(
                    color: enabled ? black : black.withOpacity(0.4),
                  ),
            ),
          Container(
            key: _widgetKey,
            height: widget.height ?? 32,
            decoration: widget.decoration ??
                BoxDecoration(
                  color: enabled ? white : disabledFieldBackground,
                  border: Border.all(color: gray2),
                  borderRadius: BorderRadius.circular(4),
                ),
            padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: getSelection(),
                ),
                widget.trailing ??
                    const VitAssetIcon(
                      asset: 'expand',
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays the options in contaner where the height is animated.
  Widget _optionsContainer() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 20.0, end: widget.optionsContainerHeight),
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 250),
      builder: (context, height, child) {
        var decorationBuilder = widget.overlayDecorationBuilder;
        BoxDecoration getDecoration() {
          if (decorationBuilder == null) return defaultOverlayDecoration;
          return decorationBuilder(height);
        }

        return Container(
          constraints: BoxConstraints(
            maxHeight: height,
          ),
          decoration: getDecoration(),
          child: child,
        );
      },
      child: _optionsContent(),
    );
  }

  Widget _optionsContent() {
    var optionsBuilder = widget.optionsBuilder;
    var options = widget.options;
    if (optionsBuilder != null) {
      return optionsBuilder(options);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = options.elementAt(index);
        var itemBuilder = widget.itemBuilder;
        if (itemBuilder == null) {
          var message = 'No item builder given to combo box.';
          return VitText.error(message);
        }
        return VitButton(
          onPressed: () async {
            var onSelected = widget.onSelected;
            if (onSelected == null) {
              debugPrint('No onSelected given to combo box');
              return;
            }
            var shouldClose = await onSelected(item);
            if (shouldClose == false) {
              return;
            }
            entry?.remove();
            var onClose = widget.onClose;
            if (onClose != null) onClose();
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: itemBuilder(item),
          ),
        );
      },
      itemCount: options.length,
    );
  }

  Widget getSelection() {
    var selectionBuilder = widget.selectedItemBuilder;
    var selection = widget.selection;
    if (selection == null) {
      if (selectionBuilder != null) {
        return selectionBuilder(null);
      }
      return const SizedBox.shrink();
    }
    T selected = widget.options.firstWhere((x) => x == selection);
    if (selectionBuilder != null) {
      return selectionBuilder(selected);
    }
    var itemBuilder = widget.itemBuilder;
    if (itemBuilder == null) {
      var message = 'No item builder given to selected item in combo box';
      return VitText.error(message);
    }
    return itemBuilder(selected);
  }
}
