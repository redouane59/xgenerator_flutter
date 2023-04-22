import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/utils.dart';

import 'config/ConfigComponent.dart';

class SelectFileList extends StatefulWidget {
  @override
  _SelectFileListState createState() => _SelectFileListState();
}

class _SelectFileListState extends State<SelectFileList> {
  int? _selectedItemId;
  String csvContent = "";
  Set<String> allTypes = new Set();
  String selectedType = "ALL";
  late final ValueNotifier<String> selectedTypeNotifier = ValueNotifier(
      selectedType); // to be able to update the selectedType (in child) from here

  List<Map<String, dynamic>> _items = [
    {
      "name": "Algerian basics",
      "id": "ALL (Algerian basics)",
      "fileName": "sample.csv",
      "type": "ALL"
    },
    {
      "name": "Algerian all",
      "id": "Algerian all",
      "fileName": "algerian_full.csv",
      "type": "ALL"
    }
  ];

  Future<void> _loadFile(String fileName) async {
    try {
      final response = await http.get(Uri.parse(fileName));
      setState(() {
        csvContent = response.body;
        allTypes = getAllTypes(csvContent, detectDelimiter(csvContent));
        Set<Map<String, dynamic>> setItems =
            Set<Map<String, dynamic>>.from(_items);
        setItems.addAll(_getItemList(fileName, allTypes));
        _items = setItems.toList();
      });
    } catch (error) {
      print('Failed to load file: $error');
    }
  }

  List<Map<String, dynamic>> _getItemList(String fileName, Set<String> types) {
    return types
        .map((type) => {
              "name": '$type ($fileName)',
              "id": '$type ($fileName)',
              "fileName": fileName,
              "type": type
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
/*          FloatingActionButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            },
            child: Icon(Icons.arrow_back),
          ),*/
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item['name']),
                    selected: _selectedItemId == item['id'],
                    onTap: () async {
                      setState(() {
                        _selectedItemId = item['id'];
                        selectedType = item['type'];
                      });
                      await _loadFile(item['fileName']);
                      // @TODO here I would like to call _ConfigComponentState.updateType(selectedType)
                      selectedTypeNotifier.value = selectedType;
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            height: 110.0, // hauteur des boutons
            child: ConfigComponent(
              selectedTypeNotifier: selectedTypeNotifier,
              csvContent: csvContent,
              allTypes: Set<String>.from([selectedType]),
              // @TODO something to add here ?
            ),
          ),
        ],
      ),
    );
  }
}
