This project focus on providing the three widgets:

- VitComboBox: A generic implementation for a combobox.

- FutureComboBox: Accepts a future as data source. While the future is not completed, a indicator is shown.

- CheckedComboBox: A combobox containing a checkboxes in its overlay.

Every implementation is focused on providing the maximum customizability. Meaning that the widget can look however you want, so it fits with your design language.

# Usage

```dart
 // Regular combo box
VitComboBox(
    label: 'My combo box',
    options: optionsSet,
    selection: selectedOption,
    itemBuilder: itemBuilder,
    onSelected: (key) {
        setState(() {
            selectedOption = key;
        });
        return null;
    },
),
```


# Limitations and known issues


- The overlay is always shown below the widget. Meaning that it is possible that the overlay is rendered partially outside the screen if the combobox is too close to the end of the screen.