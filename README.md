This project focus on providing the three widgets:

- VitComboBox: A generic implementation for a combobox.

- FutureComboBox: Accepts a future as data source. While the future is not completed, a indicator is shown.

- CheckedComboBox: A combobox containing a checkboxes in its overlay.

Every implementation is focused on providing the maximum customizability. Meaning that the widget can look however you want, so it fits with your design language.

<img width="571" alt="Screenshot 2024-03-22 at 14 29 00" src="https://github.com/TimeLord2010/vit_combo_box/assets/50129092/3181fb60-6e6f-4e7f-bfe7-b845f4ac1027">

<img width="571" alt="Screenshot 2024-03-22 at 14 29 09" src="https://github.com/TimeLord2010/vit_combo_box/assets/50129092/faaad685-d7fc-42ec-81b0-f28df9e717e0">

<img width="573" alt="Screenshot 2024-03-22 at 14 29 21" src="https://github.com/TimeLord2010/vit_combo_box/assets/50129092/8ed3aa86-71ba-4c4d-9499-6cd781a381d5">


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
