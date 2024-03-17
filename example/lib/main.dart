import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitComboBox(
          options: List.generate(20, (index) {
            return DateTime(2000 + index);
          }).toSet(),
          selection: DateTime(2000),
          itemBuilder: (item) {
            return Text('Year ${item.year}');
          },
          onSelected: (key) {
            return null;
          },
          label: 'Date',
        ),
      ],
    );
  }
}
