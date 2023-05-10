// firebase deploy --only hosting:train-mee
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/utils.dart';

import 'FileInputComponent.dart';
import 'FreeTextComponent.dart';

// flutter build web
// firebase deploy --only hosting:train-mee
void main() {
  runApp(MyApp(csvContent: ''));
}

class MyApp extends StatefulWidget {
  String csvContent;

  MyApp({required this.csvContent});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _csvContent = '';
  int _activeTabIndex = 0;
  List<String> files = [];
  List<String> types = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _csvContent = widget.csvContent;
    _loadAssetFiles();
  }

  void updateCSVContent(newContent) {
    setState(() {
      _csvContent = newContent;
    });
  }

  Future<void> _loadAssetFiles() async {
    List<String> knownAssetFileNames = [
      'algerian basics.csv',
      'algerian darja.csv',
      'country capitals.csv'
    ];

    List<String> assetFiles = [];
    for (String fileName in knownAssetFileNames) {
      final response = await http.get(Uri.parse(fileName));

      if (response.statusCode == 200) {
        assetFiles.add(fileName);
      } else {
        print('Failed to load content from file: $fileName');
      }
    }

    if (assetFiles.isEmpty) {
      print('no files found !');
    }
    setState(() {
      files = assetFiles;
    });
  }

  Future<void> _loadCsvTypes(String fileName) async {
    final response = await http.get(Uri.parse(fileName));
    if (response.statusCode == 200) {
      final csvContent = response.body;
      final delimiter = detectDelimiter(csvContent);
      final allTypes = getAllTypes(csvContent, delimiter);

      //    print('types found : $allTypes');

      setState(() {
        types = allTypes.toList();
      });
    } else {
      print('Failed to load types from file: $fileName');
    }
  }

  Future<void> _loadCsvContent(String fileName, String type) async {
    print('loadCSVContent');
    final response = await http.get(Uri.parse('$fileName'));

    if (response.statusCode == 200) {
      final csvContent = utf8.decode(response.bodyBytes);
      String delimiter = detectDelimiter(csvContent);
      final converter = CsvToListConverter(fieldDelimiter: delimiter);
      final rows = converter.convert(csvContent);
      var filteredRows;
      if (type != 'ALL') {
        filteredRows =
            rows.where((row) => row.length > 2 && row[2] == type).toList();
      } else {
        filteredRows = rows.where((row) => row.length > 1).toList();
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
      print('Failed to load content from file: $fileName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Train Me!'),
        ),
        drawer: Drawer(
          child: Builder(builder: (context) {
            return ListView(
              children: [
                DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Text(
                    'Load existing exercises',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      for (String file in files)
                        ExpansionTile(
                          title: Text(file),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: types.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final type = types[index];
                                  return ListTile(
                                    title: Text(type),
                                    onTap: () {
                                      // Perform any action when the type is tapped
                                      Navigator.pop(context);
                                      _loadCsvContent(file,
                                          type); // Charger le contenu du fichier CSV
                                    },
                                  );
                                },
                              ),
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
                        ),
                    ],
                  ),
                ),
              ],
            );
          }),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.travel_explore_rounded),
              label: 'Browse existing exercises',
            ),
          ],
          currentIndex: _activeTabIndex,
          onTap: (int index) {
            setState(() {
              _activeTabIndex = index;
            });
            if (index == 2) {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
        body: IndexedStack(
          index: _activeTabIndex,
          children: [
            FreeTextComponent(
              csvContent: _csvContent,
              updateCSVContent: updateCSVContent,
            ),
            FileInputComponent(),
            FreeTextComponent(
                csvContent: _csvContent, updateCSVContent: updateCSVContent),
          ],
        ),
      ),
    );
  }
}
