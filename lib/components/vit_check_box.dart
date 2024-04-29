// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class VitCheckBox extends StatelessWidget {
  const VitCheckBox({
    super.key,
    required this.isChecked,
    required this.onChecked,
  });

  final bool isChecked;
  final void Function(bool value)? onChecked;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (v) {
        if (onChecked != null) {
          onChecked!(v ?? false);
        }
      },
    );
  }
}
