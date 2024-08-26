## 4.2.0

* Added `padding` options to `ComboBoxStyle`.
* Added `duration`, `startingHeight`, and `curve` to `OptionsStyle`.

## 4.1.0

* `VitComboBox.optionsBuilder` now has the parameter "entry" to close the overlay.
* `selectedItemBuilder` from `VitComboBox.rawBuilder` now does not have the parameter "selection".

## 4.0.4

* `OptionStyle.padding` now affect the underlying ListView instead of the container.

## 4.0.3

* Added theme classes to the package export.

## 4.0.2

* Added parameter "onChecked" to `renderCheckBox` from `CheckedComboBox`.

## 4.0.1

* Added documentation to various elements.

## 4.0.0

* [BREAKING] Reworked `VitComboBox` base class contructor into named constructors `.rawBuilder` and `.itemBuilder`.
* [BREAKING] Style related properties from all combo boxes were refactored and grouped inside `VitComboBoxStyle` to improve reuse and and readability.
* Fixed a bug where `CheckedComboBox` only updated its selection when the option overlay was closed.
* Added property `padding` to options style class `OptionsStyle`.


## 3.1.0

* Added `labelStyle` to `VitComboBoxThemeData`.

## 3.0.1

* `parentRenderBoxGetter` now has the BuilContext in its parameters.

## 3.0.0

* [BREAKING] `getParentRenderBox` was renamed to `parentRenderBoxGetter`.
* Added `VitComboBoxTheme`.
* The expand icon now is gray when `enabled` is false.

## 2.1.1

* Fixed the options container position.

## 2.1.0

* Added `optionsOffset` and `getParentRenderBox` fields to combo box constructors;

## 2.0.1

* Updated README.md.

## 2.0.0

* [BREAKING] `builder` option in FutureComboBox was renamed to `itemBuilder`.
* [BREAKING] Removed `.chip` factory from `VitComboBox`.
* Added `labelStyle` option to combo box.
* Added `overlayDecorationBuilder` option to customize the overlay container.

## 1.0.0

* First release.
