import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/combo_boxes/vit_combo_box.dart';
import 'package:vit_combo_box/components/vit_button.dart';
import 'package:vit_combo_box/components/vit_check_box.dart';
import 'package:vit_combo_box/extensions/iterable_extension.dart';

/// A combo box with checked boxes at the left of each item.
///
/// The options overlay does not close when a check box is checked.
class CheckedComboBox<T> extends StatelessWidget {
  const CheckedComboBox({
    super.key,
    required this.options,
    required this.itemBuilder,
    required this.selectedItems,
    this.onSelected,
    this.label,
    this.enabled = true,
    this.selectionBuilder,
    this.onClose,
    this.renderCheckBox,
    this.labelStyle,
    this.overlayDecorationBuilder,
    this.getParentRenderBox,
    this.optionsOffset,
    this.height,
    this.decoration,
    this.optionsContainerHeight,
  });

  final Set<T> options;
  final Set<T> selectedItems;
  final String? label;
  final TextStyle? labelStyle;
  final bool enabled;
  final BoxDecoration Function(double height)? overlayDecorationBuilder;
  final Widget Function(T item) itemBuilder;
  final void Function(T item, bool selected)? onSelected;
  final Widget Function()? selectionBuilder;
  final Widget Function(bool isChecked)? renderCheckBox;
  final void Function()? onClose;
  final Offset? optionsOffset;
  final RenderBox? Function()? getParentRenderBox;
  final double? height;
  final BoxDecoration? decoration;
  final double? optionsContainerHeight;

  @override
  Widget build(BuildContext context) {
    return VitComboBox(
      label: label,
      labelStyle: labelStyle,
      options: options,
      enabled: enabled,
      onClose: onClose,
      height: height,
      decoration: decoration,
      overlayDecorationBuilder: overlayDecorationBuilder,
      getParentRenderBox: getParentRenderBox,
      optionsOffset: optionsOffset,
      optionsContainerHeight: optionsContainerHeight,
      selectedItemBuilder: (_) {
        var builder = selectionBuilder;
        if (builder == null) {
          return Wrap(
            children: selectedItems
                .map((x) {
                  return itemBuilder(x);
                })
                .separatedBy(const Text(', '))
                .toList(),
          );
        }
        return builder();
      },
      optionsBuilder: (options) {
        return StatefulBuilder(
          builder: (context, setState) {
            return _renderOptions(
              options: options,
              selectedItems: selectedItems,
              onSelection: (item, value) {
                if (onSelected != null) onSelected!(item, value);
                if (value) {
                  selectedItems.add(item);
                } else {
                  selectedItems.remove(item);
                }
                setState(() {});
              },
            );
          },
        );
      },
    );
  }

  ListView _renderOptions({
    required Set<dynamic> options,
    required Set<T> selectedItems,
    required void Function(T item, bool selected) onSelection,
  }) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var item = options.elementAt(index);
        var isChecked = selectedItems.contains(item);
        onChecked(bool value) => onSelection(item, value);

        Widget buildCheckBox() {
          if (renderCheckBox == null) {
            return VitCheckBox(
              isChecked: isChecked,
              onChecked: onChecked,
            );
          }
          return renderCheckBox!(isChecked);
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: VitButton(
            onPressed: () => onChecked(!isChecked),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    buildCheckBox(),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () => onChecked(!isChecked),
                        ),
                      ),
                    ),
                  ],
                ),
                itemBuilder(item),
              ],
            ),
          ),
        );
      },
      itemCount: options.length,
    );
  }
}
