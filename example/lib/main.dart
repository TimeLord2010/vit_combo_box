import 'package:flutter/material.dart';
import 'package:vit_combo_box/theme/style/combo_box_style.dart';
import 'package:vit_combo_box/theme/style/vit_combo_box_style.dart';
import 'package:vit_combo_box/vit_combo_box.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Vit combo box'),
      ),
      body: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? selectedDate;
  Set<DateTime> selectedDates = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var set = List.generate(20, (index) {
      return DateTime(2000 + index);
    }).toSet();
    itemBuilder(DateTime item) => Text('Year ${item.year}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Regular combo box
          VitComboBox.itemBuilder(
            options: set,
            selection: selectedDate,
            itemBuilder: itemBuilder,
            onSelected: (key) {
              setState(() {
                selectedDate = key;
              });
              return null;
            },
            label: 'Date',
          ),

          const SizedBox(height: 20),

          VitComboBox.itemBuilder(
            options: set,
            selection: selectedDate,
            itemBuilder: itemBuilder,
            onSelected: (key) {
              setState(() {
                selectedDate = key;
              });
              return null;
            },
            enabled: false,
            label: 'Disabled',
          ),

          const SizedBox(height: 20),

          VitComboBoxTheme(
            data: VitComboBoxThemeData(
              style: VitComboBoxStyle(
                comboBox: ComboBoxStyle(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                  ),
                ),
              ),
            ),
            child: VitComboBox.itemBuilder(
              options: const {true, false},
              label: 'With decoration from theme',
              itemBuilder: (item) {
                return Text(item.toString());
              },
              onSelected: (key) {
                return null;
              },
            ),
          ),

          const SizedBox(height: 20),

          // Combo box with check boxes.
          CheckedComboBox<DateTime>(
            options: set,
            itemBuilder: (item) {
              return Text('Year ${item.year}');
            },
            selectedItems: selectedDates,
            onSelected: (item, selected) {
              if (selected) {
                selectedDates.add(item);
              } else {
                selectedDates.remove(item);
              }
            },
            onClose: () {
              setState(() {});
            },
            label: 'Combo box with check boxes',
          ),

          const SizedBox(height: 20),

          FutureComboBox.eternal(
            label: 'Combo box that needs to load some data [ It never gets them 😔 ]',
          ),
        ],
      ),
    );
  }
}
