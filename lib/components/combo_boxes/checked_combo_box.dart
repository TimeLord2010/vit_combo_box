import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/combo_boxes/vit_combo_box.dart';
import 'package:vit_combo_box/components/vit_button.dart';
import 'package:vit_combo_box/components/vit_check_box.dart';
import 'package:vit_combo_box/extensions/iterable_extension.dart';
import 'package:vit_combo_box/theme/style/vit_combo_box_style.dart';

/// A combo box with checked boxes at the left of each item.
///
/// The options overlay does not close when a check box is checked.
class CheckedComboBox<T> extends StatefulWidget {
  /// Creates an instance of the checked combo box class.
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
    this.style,
  });

  /// The options used to create the options overlay.
  final Set<T> options;

  /// A set of the items currently selected by the combobox overlay.
  final Set<T> selectedItems;

  /// A text displayed at the top of the combo box.
  final String? label;

  /// Whether to allow interaction of the combobox.
  final bool enabled;

  /// Function used to build each item of the option overlay.
  final Widget Function(T item) itemBuilder;

  /// Function called when an item is selected.
  final void Function(T item, bool selected)? onSelected;

  /// The function to build the selected item.
  final Widget Function()? selectionBuilder;

  /// Used to build the checkbox, not including the text.
  final Widget Function(bool isChecked, void Function(bool value) onCheck)? renderCheckBox;

  /// Called when the overlay is closed.
  final void Function()? onClose;

  /// The style of the combobox.
  final VitComboBoxStyle? style;

  @override
  State<CheckedComboBox<T>> createState() => _CheckedComboBoxState<T>();
}

class _CheckedComboBoxState<T> extends State<CheckedComboBox<T>> {
  @override
  Widget build(BuildContext context) {
    return VitComboBox.rawBuilder(
      label: widget.label,
      style: widget.style,
      enabled: widget.enabled,
      onClose: widget.onClose,
      selectedItemBuilder: () {
        var builder = widget.selectionBuilder;
        if (builder == null) {
          return Wrap(
            children: widget.selectedItems
                .map((x) {
                  return widget.itemBuilder(x);
                })
                .separatedBy(const Text(', '))
                .toList(),
          );
        }
        return builder();
      },
      optionsBuilder: (entry) {
        return StatefulBuilder(
          builder: (context, updateOptions) {
            return _renderOptions(
              options: widget.options,
              selectedItems: widget.selectedItems,
              onSelection: (item, value) {
                if (widget.onSelected != null) widget.onSelected!(item, value);
                if (value) {
                  widget.selectedItems.add(item);
                } else {
                  widget.selectedItems.remove(item);
                }
                updateOptions(() {});
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
          if (widget.renderCheckBox == null) {
            return VitCheckBox(
              isChecked: isChecked,
              onChecked: onChecked,
            );
          }
          return widget.renderCheckBox!(isChecked, onChecked);
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
                widget.itemBuilder(item),
              ],
            ),
          ),
        );
      },
      itemCount: options.length,
    );
  }
}
