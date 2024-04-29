// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

/// A icon with source file in .webp format and located at
/// lib/assets/<asset>.webp
class VitAssetIcon extends StatelessWidget {
  final double? size;
  final String asset;
  final Color? color;

  const VitAssetIcon({
    super.key,
    required this.asset,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var size = this.size ?? 25;
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'packages/vit_combo_box/assets/$asset.webp',
        color: color,
      ),
    );
  }
}
