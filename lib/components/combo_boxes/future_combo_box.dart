import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vit_combo_box/components/combo_boxes/vit_combo_box.dart';
import 'package:vit_combo_box/components/vit_text.dart';
import 'package:vit_combo_box/theme/style/vit_combo_box_style.dart';

/// A combobox with no items and displaying an loading indicator in place of
/// the selected item.
class FutureComboBox<T> extends StatelessWidget {
  /// A combobox displaying a progress indicator while the future [options] is
  /// not completed.
  const FutureComboBox({
    super.key,
    required this.options,
    required this.itemBuilder,
    required this.onSelected,
    this.onError,
    this.label,
    this.loaderBuilder,
    this.style,
  });

  /// A combobox that a future that only finishes after a day.
  factory FutureComboBox.eternal({
    String? label,
    Widget Function()? loaderBuilder,
    VitComboBoxStyle? style,
  }) {
    return FutureComboBox(
      label: label,
      loaderBuilder: loaderBuilder,
      style: style,
      options: Future.delayed(const Duration(days: 1), () {
        return {};
      }),
      itemBuilder: (item) {
        throw Exception('Tried to render item in eternal future combo box');
      },
      onSelected: (item) => null,
    );
  }

  /// A future that results in the options for the combobox.
  final Future<Set<T>> options;

  /// A text displayed at the top of the combobox.
  final String? label;

  /// A function used to display an error in case options future throws an
  /// exception.
  final Widget Function(Object error)? onError;

  /// The builder function used to create each item of the combo box.
  final Widget Function(T item) itemBuilder;

  /// The function used to build the widget while the future is in progress.
  final Widget Function()? loaderBuilder;

  /// A function called when the item is selected.
  final FutureOr<bool?> Function(T item) onSelected;

  /// The style used to decorate the component.
  final VitComboBoxStyle? style;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: options,
      builder: (context, snapshot) {
        return switch (snapshot.connectionState) {
          ConnectionState.waiting => _renderLoading(context),
          ConnectionState.done => _content(snapshot.data, snapshot.error),
          ConnectionState.none => VitText.error('Invalid state: no future given'),
          ConnectionState.active => _content(snapshot.data, null),
        };
      },
    );
  }

  VitComboBox<bool> _renderLoading(BuildContext context) {
    return VitComboBox<bool>.itemBuilder(
      options: const {false},
      style: style,
      itemBuilder: (item) {
        if (loaderBuilder != null) {
          return loaderBuilder!();
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
      onSelected: (key) => null,
      selection: false,
      label: label,
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
      return VitComboBox.itemBuilder(
        label: label,
        options: items,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        style: style,
      );
    }
    throw StateError('Either items or error must not be null');
  }
}
