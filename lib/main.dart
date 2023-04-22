// firebase deploy --only hosting:train-mee
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/utils.dart';

import 'FileInputComponent.dart';
import 'FreeTextComponent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _activeTabIndex = 0;
  List<String> files = [];
  List<String> types = [];
  String _csvContent = '';

  @override
  void initState() {
    super.initState();
    _loadAssetFiles();
  }

  void updateCSVContent(newContent) {
    setState(() {
      _csvContent = newContent;
    });
  }

  Future<void> _loadAssetFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final assetFiles = manifestMap.keys
        .where((String key) => key.startsWith('web/') && key.endsWith('.csv'))
        .map((e) => e.replaceAll('web/', '').replaceAll('.csv', ''))
        .toList();

    setState(() {
      files = assetFiles;
    });
  }

  Future<void> _loadCsvTypes(String fileName) async {
    final response = await http.get(Uri.parse('web/$fileName.csv'));
    if (response.statusCode == 200) {
      final csvContent = response.body;
      final delimiter = detectDelimiter(csvContent);
      final allTypes = getAllTypes(csvContent, delimiter);

      setState(() {
        types = allTypes.toList();
      });
    } else {
      print('Failed to load types from file: $fileName.csv');
    }
  }

  Future<void> _loadCsvContent(String fileName, String type) async {
    final response = await http.get(Uri.parse('web/$fileName.csv'));

    if (response.statusCode == 200) {
      final csvContent = utf8.decode(response.bodyBytes);
      final rows = const CsvToListConverter().convert(csvContent);
      var filteredRows;
      if (type != 'ALL') {
        filteredRows = rows
            .where((row) => row.length > 2 && row[2] == type)
            .map((row) => row.sublist(0, 2))
            .toList();
      } else {
        filteredRows = rows
            .where((row) => row.length > 1)
            .map((row) => row.sublist(0, 2))
            .toList();
      }
      final filteredCsvContent =
          const ListToCsvConverter().convert(filteredRows);
      if (filteredCsvContent.isEmpty) {
        print('empty filteredCsvContent');
      }
      setState(() {
        _csvContent = filteredCsvContent;
        _activeTabIndex = 0; // Change to the FreeTextComponent tab
      });
    } else {
      print('Failed to load content from file: $fileName.csv');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Train Me!'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Text(
                  'Load existing exerices',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (BuildContext context, int index) {
                  final file = files[index];
                  return ExpansionTile(
                    title: Text(file),
                    children: [
                      for (String type in types)
                        ListTile(
                          title: Text(type),
                          onTap: () {
                            // Perform any action when the type is tapped
                            Navigator.pop(context);
                            _loadCsvContent(file,
                                type); // Charger le contenu du fichier CSV
                          },
                        ),
                    ],
                    onExpansionChanged: (bool isExpanded) async {
                      if (isExpanded) {
                        await _loadCsvTypes(file);
                      } else {
                        setState(() {
                          types = [];
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.paste),
              label: 'Paste raw text',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload_file),
              label: 'Import a CSV file',
            ),
          ],
          currentIndex: _activeTabIndex,
          onTap: (int index) {
            setState(() {
              _activeTabIndex = index;
            });
          },
        ),
        body: IndexedStack(
          index: _activeTabIndex,
          children: [
            FreeTextComponent(
                csvContent: _csvContent, updateCSVContent: updateCSVContent),
            FileInputComponent()
          ],
        ),
      ),
    );
  }
}
