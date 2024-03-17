import 'package:flutter/widgets.dart';

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
