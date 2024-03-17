import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/vit_text.dart';

class VitCheckBox extends StatelessWidget {
  const VitCheckBox({
    super.key,
    required this.isChecked,
    required this.onChecked,
    required this.label,
  });

  final bool isChecked;
  final void Function(bool value) onChecked;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (v) {
            onChecked(v ?? false);
          },
        ),
        VitText(label),
      ],
    );
  }
}
