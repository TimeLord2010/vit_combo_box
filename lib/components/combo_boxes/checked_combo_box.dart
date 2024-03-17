import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/components/combo_boxes/vit_combo_box.dart';
import 'package:vit_combo_box/components/vit_check_box.dart';

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
  });

  final Set<T> options;
  final Set<T> selectedItems;
  final String? label;
  final bool enabled;
  final String Function(T item) itemBuilder;
  final void Function(T item, bool selected)? onSelected;

  @override
  Widget build(BuildContext context) {
    return VitComboBox(
      label: label,
      options: options,
      enabled: enabled,
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: VitCheckBox(
            isChecked: selectedItems.contains(item),
            onChecked: (value) => onSelection(item, value),
            label: itemBuilder(item),
          ),
        );
      },
      itemCount: options.length,
    );
  }
}
