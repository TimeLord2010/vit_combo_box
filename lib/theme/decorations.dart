import 'package:flutter/widgets.dart';
import 'package:vit_combo_box/theme/colors.dart';

/// The default options overlay decoration.
final defaultOverlayDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 255, 255, 255),
  borderRadius: BorderRadius.circular(3),
  boxShadow: [
    BoxShadow(
      spreadRadius: 3,
      offset: const Offset(2, 2),
      color: black.withOpacity(0.2),
      blurRadius: 4,
    ),
  ],
);
