// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/components/vit_asset_icon.dart';

class VitButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;

  const VitButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  factory VitButton.asset({
    required void Function() onPressed,
    required String asset,
    double? size,
    Color? color,
  }) {
    return VitButton(
      onPressed: onPressed,
      child: VitAssetIcon(
        asset: asset,
        size: size,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onPressed == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: child,
      ),
    );
  }
}
