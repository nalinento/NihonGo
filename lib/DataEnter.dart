import 'package:flutter/material.dart';
import 'package:nihon/DataBaseHelper.dart';




class DataEntryPage extends StatefulWidget {
  @override
  _DataEntryPageState createState() => _DataEntryPageState();


}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController sinhalaController = TextEditingController();
  final TextEditingController japanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: sinhalaController,
              decoration: InputDecoration(labelText: 'Sinhala'),
            ),
            TextField(
              controller: japanController,
              decoration: InputDecoration(labelText: 'Japan'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveData();
              },
              child: Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveData() async {
    final sinhala = sinhalaController.text;
    final japan = japanController.text;

    if (sinhala.isNotEmpty && japan.isNotEmpty) {
      final dbHelper = DatabaseHelper.instance;
      final result = await dbHelper.insertData(sinhala, japan);

      if (result != -1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data saved successfully with ID $result'),
        ));
        // Clear the text fields
        sinhalaController.clear();
        japanController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save data.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both Sinhala and Japan word.'),
      ));
    }
  }

}