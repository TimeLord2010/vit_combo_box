// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class VitText extends StatelessWidget {
  const VitText(
    this.text, {
    super.key,
    this.style,
  });

  factory VitText.error(String text) {
    return VitText(
      text,
      style: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle().merge(style),
      overflow: TextOverflow.ellipsis,
    );
  }
}
