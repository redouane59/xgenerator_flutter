import 'package:flutter/material.dart';

import 'PlayButtons.dart';

class SelectFileList extends StatefulWidget {
  @override
  _SelectFileListState createState() => _SelectFileListState();
}

class _SelectFileListState extends State<SelectFileList> {
  int? _selectedItemId;
  String csvContent = "";

  final List<Map<String, dynamic>> _items = [
    {
      "name": "Algerian basics",
      "id": 1,
      "fileName": "sample.csv",
    },
    {
      "name": "Algerian all",
      "id": 2,
      "fileName": "algerian_full.csv",
    }
  ];

  TextStyle get _itemTitleTextStyle {
    return MediaQuery.of(context).size.width <= 768
        ? TextStyle(fontSize: 18.0)
        : TextStyle(fontSize: 24.0);
  }

  Future<void> _loadFile(String fileName) async {
    try {
      final response =
          await DefaultAssetBundle.of(context).loadString(fileName);
      setState(() {
        csvContent = response;
      });
      //   widget.finishFileUpload(response);
    } catch (error) {
      print('Failed to load file: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item['name'], style: _itemTitleTextStyle),
                  selected: _selectedItemId == item['id'],
                  onTap: () async {
                    print('onTap');
                    setState(() {
                      _selectedItemId = item['id'];
                    });
                    await _loadFile(item['fileName']);
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100.0, // hauteur des boutons
              child: PlayButtons(csvContent: csvContent),
            ),
          ),
        ],
      ),
    );
  }
}
