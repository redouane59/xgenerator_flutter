// firebase deploy --only hosting:train-mee
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/utils.dart';

import 'FileInputComponent.dart';
import 'FreeTextComponent.dart';
import 'SelectFileList.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAssetFiles();
  }

  Future<void> _loadAssetFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final assetFiles = manifestMap.keys
        .where((String key) => key.startsWith('web/') && key.endsWith('.csv'))
        .map((e) => e.replaceAll('web/', '').replaceAll('.csv', ''))
        .toList();

    print('$assetFiles');

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Train Me!'),
        ),
        drawer: Drawer(
          child: ListView.builder(
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
              icon: Icon(Icons.folder_open),
              label: 'Existing exercises',
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
            FreeTextComponent(),
            FileInputComponent(),
            SelectFileList(),
          ],
        ),
      ),
    );
  }
}
