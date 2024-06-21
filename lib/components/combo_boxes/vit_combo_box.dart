import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/vit_asset_icon.dart';
import 'package:vit_combo_box/components/vit_button.dart';
import 'package:vit_combo_box/components/vit_text.dart';
import 'package:vit_combo_box/theme/colors.dart';
import 'package:vit_combo_box/theme/decorations.dart';
import 'package:vit_combo_box/theme/style/index.dart';
import 'package:vit_combo_box/theme/vit_combo_box_theme.dart';
import 'package:vit_combo_box/usecases/get_widget_position.dart';
import 'package:vit_combo_box/usecases/get_widget_size_by_key.dart';

/// A widget similar to a text box, but on tap, a overlay of options is shown
/// below it, allowing the user to choose an option.
class VitComboBox<T> extends StatefulWidget {
  VitComboBox._({
    super.key,
    this.options,
    this.label,
    this.selection,
    this.itemBuilder,
    this.onSelected,
    this.selectedItemBuilder,
    this.optionsBuilder,
    this.onClose,
    this.trailing,
    this.style,
    this.enabled = true,
  }) {
    assert(
      optionsBuilder != null || itemBuilder != null,
      'Either optionsBuilder or itemBuilder must be given',
    );
    assert(
      options != null || optionsBuilder != null,
      'Either options or optionsBuilder must be given',
    );
    assert(options != null || selectedItemBuilder != null, 'Either options or selectedItemBuilder must be given');
    assert(
      (optionsBuilder != null && itemBuilder == null) || (itemBuilder != null && optionsBuilder == null),
      'If optionsBuilder is given, then itemBuilder must be null. The same if itemBuilder is given instead',
    );
    assert(
      itemBuilder == null || onSelected != null,
      'If itemBuilder is given, then onSelected must be also given',
    );
  }

  /// Creates a combobox with a custom option overlay by providing
  /// [optionsBuilder].
  factory VitComboBox.rawBuilder({
    required Widget Function(OverlayEntry entry) optionsBuilder,
    required Widget Function() selectedItemBuilder,
    void Function()? onClose,
    String? label,
    VitComboBoxStyle? style,
    T? selection,
    Widget? trailing,
    bool enabled = true,
  }) {
    return VitComboBox._(
      label: label,
      optionsBuilder: optionsBuilder,
      selectedItemBuilder: (_) => selectedItemBuilder(),
      onClose: onClose,
      style: style,
      enabled: enabled,
      selection: selection,
      trailing: trailing,
    );
  }

  /// Creates a combobox with option overlay using the [ListView] and
  /// [itemBuilder].
  factory VitComboBox.itemBuilder({
    required Set<T> options,
    required Widget Function(T item) itemBuilder,
    required FutureOr<bool?> Function(T key) onSelected,
    Widget Function(T? selection)? selectedItemBuilder,
    void Function()? onClose,
    String? label,
    VitComboBoxStyle? style,
    T? selection,
    Widget? trailing,
    bool enabled = true,
  }) {
    return VitComboBox._(
      options: options,
      itemBuilder: itemBuilder,
      selectedItemBuilder: selectedItemBuilder,
      onSelected: onSelected,
      style: style,
      enabled: enabled,
      label: label,
      onClose: onClose,
      selection: selection,
      trailing: trailing,
    );
  }

  /// The text displayed above it so indicate to the user with field this
  /// component belongs to
  final String? label;

  /// The current item selected between [options].
  final T? selection;

  /// The options used to create the options overlay.
  final Set<T>? options;

  /// A group of properies relating to the component style.
  final VitComboBoxStyle? style;

  /// Indicates to the user whether the widget is interactiable or not.
  final bool enabled;

  /// Optional parameter to build a custom layout when the widget is selected.
  final Widget Function(OverlayEntry entry)? optionsBuilder;

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

  @override
  Widget build(BuildContext context) {
    var label = widget.label;
    var enabled = widget.enabled;
    return VitButton(
      onPressed: enabled ? _onPressed : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          if (label != null) VitText(label, style: _labelStyle()),

          // Combobox
          Container(
            key: _widgetKey,
            height: _comboBoxStyle?.height,
            decoration: _getDecoration(),
            padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _getSelection(),
                ),
                widget.trailing ?? _getDefaultSuffix(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed() {
    entry = OverlayEntry(
      builder: (context) {
        var position = getWidgetPosition(
          key: _widgetKey,
          parent: _getParent(),
        );
        var size = getWidgetSize(_widgetKey);

        var offset = _optionsStyle?.offset;
        if (offset != null) {
          position += offset;
        }

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

  TextStyle _labelStyle() {
    // Instance style
    var localStyle = widget.style?.label;
    if (localStyle != null) return localStyle;

    // Theme style
    var themeStyle = VitComboBoxTheme.maybeOf(context)?.label;
    if (themeStyle != null) return themeStyle;

    // Default style
    var enabled = widget.enabled;
    return TextStyle(
      color: enabled ? black : black.withOpacity(0.4),
    );
  }

  OptionsStyle? get _optionsStyle {
    var localStyle = widget.style?.options;
    if (localStyle != null) return localStyle;

    var theme = VitComboBoxTheme.maybeOf(context)?.options;
    if (theme != null) return theme;

    return null;
  }

  ComboBoxStyle? get _comboBoxStyle {
    var localStyle = widget.style?.comboBox;
    if (localStyle != null) return localStyle;

    var themeStyle = VitComboBoxTheme.maybeOf(context)?.comboBox;
    if (themeStyle != null) return themeStyle;

    return null;
  }

  BoxDecoration _getDecoration() {
    var decoration = _comboBoxStyle?.decoration;
    if (decoration != null) return decoration;

    // Default decoration
    var enabled = widget.enabled;
    return BoxDecoration(
      color: enabled ? white : disabledFieldBackground,
      border: Border.all(color: gray2),
      borderRadius: BorderRadius.circular(4),
    );
  }

  VitAssetIcon _getDefaultSuffix() {
    return VitAssetIcon(
      asset: 'expand',
      color: widget.enabled ? null : const Color.fromARGB(255, 135, 135, 135),
    );
  }

  /// Displays the options in contaner where the height is animated.
  Widget _optionsContainer() {
    return TweenAnimationBuilder(
      tween: Tween<double>(
        begin: 20.0,
        end: _optionsStyle?.containerHeight ?? 150,
      ),
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 250),
      builder: (context, height, child) {
        var decorationBuilder = _optionsStyle?.decorationBuilder;
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
      return optionsBuilder(entry!);
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: _optionsStyle?.padding,
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
      itemCount: options!.length,
    );
  }

  Widget _getSelection() {
    var selectionBuilder = widget.selectedItemBuilder;
    var selection = widget.selection;
    if (selection == null) {
      if (selectionBuilder != null) {
        return selectionBuilder(null);
      }
      return const SizedBox.shrink();
    }
    if (selectionBuilder != null) {
      return selectionBuilder(selection);
    }
    T selected = widget.options!.firstWhere((x) => x == selection);
    var itemBuilder = widget.itemBuilder;
    if (itemBuilder == null) {
      var message = 'No item builder given to selected item in combo box';
      return VitText.error(message);
    }
    return itemBuilder(selected);
  }

  RenderBox? _getParent() {
    var func = widget.style?.parentRenderBoxGetter;
    if (func != null) return func(context);

    var themeGetter = VitComboBoxTheme.maybeOf(context)?.parentRenderBoxGetter;
    if (themeGetter != null) return themeGetter(context);
    return null;
  }
}
