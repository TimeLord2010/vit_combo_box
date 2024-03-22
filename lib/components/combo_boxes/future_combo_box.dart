import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/combo_boxes/vit_combo_box.dart';
import 'package:vit_combo_box/components/vit_text.dart';

/// A combobox with no items and displaying an loading indicator in place of
/// the selected item.
class FutureComboBox<T> extends StatelessWidget {
  const FutureComboBox({
    super.key,
    required this.options,
    required this.itemBuilder,
    required this.onSelected,
    this.onError,
    this.label,
    this.loaderBuilder,
    this.labelStyle,
  });

  factory FutureComboBox.eternal({String? label, Widget Function()? loaderBuilder}) {
    return FutureComboBox(
      label: label,
      loaderBuilder: loaderBuilder,
      options: Future.delayed(const Duration(days: 1), () {
        return {};
      }),
      itemBuilder: (item) {
        throw Exception('Tried to render item in eternal future combo box');
      },
      onSelected: (item) => null,
    );
  }

  final Future<Set<T>> options;
  final String? label;
  final Widget Function(Object error)? onError;
  final Widget Function(T item) itemBuilder;
  final Widget Function()? loaderBuilder;
  final FutureOr<bool?> Function(T item) onSelected;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: options,
      builder: (context, snapshot) {
        return switch (snapshot.connectionState) {
          ConnectionState.waiting => _renderLoading(),
          ConnectionState.done => _content(snapshot.data, snapshot.error),
          ConnectionState.none => VitText.error('Invalid state: no future given'),
          ConnectionState.active => _content(snapshot.data, null),
        };
      },
    );
  }

  VitComboBox<bool> _renderLoading() {
    return VitComboBox<bool>(
      options: const {false},
      itemBuilder: (item) {
        if (loaderBuilder != null) {
          return loaderBuilder!();
        }
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
      onSelected: (key) => null,
      selection: false,
      label: label,
      labelStyle: labelStyle,
    );
  }

  Widget _content(Set<T>? items, Object? error) {
    if (error != null) {
      var errorHandler = onError;
      if (errorHandler == null) {
        throw error;
      }
      return errorHandler(error);
    }
    if (items != null) {
      return VitComboBox(
        label: label,
        options: items,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        labelStyle: labelStyle,
      );
    }
    throw StateError('Either items or error must not be null');
  }
}
